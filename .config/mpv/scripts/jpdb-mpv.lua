local utils = require "mp.utils"
local has_ffi, ffi = pcall( require, "ffi" )
if has_ffi then
    if ffi.os == "OSX" then
        ffi.cdef[[
            typedef unsigned short mode_t;
        ]]
    else
        ffi.cdef[[
            typedef unsigned int mode_t;
        ]]
    end

    ffi.cdef[[
        int open( const char *, int, mode_t );
        int close( int );
        int ftruncate( int, size_t );
        void * mmap( void *, size_t, int, int, int, size_t );
        int munmap( void *, size_t );
        int shm_open( const char *, int, mode_t );
        int shm_unlink( const char * );

        unsigned long strtoul( const char *, char **, int );
        int atoi( const char * );

        __stdcall void * OpenFileMappingA( unsigned long, int, const char * );
        __stdcall void * MapViewOfFile( void *, unsigned long, unsigned long, unsigned long, size_t );

        typedef struct GUID {
            unsigned long Data1;
            unsigned short Data2;
            unsigned short Data3;
            unsigned char Data4[8];
        } GUID;
        __stdcall long SHGetKnownFolderPath( GUID * rfid, unsigned long, void *, unsigned short ** );
        __stdcall int WideCharToMultiByte( unsigned int, unsigned long, const unsigned short *, int, char *, int, const char *, bool * );
        __stdcall void CoTaskMemFree( void * );
    ]]
end

function strtoul( string )
    return ffi.C.strtoul( string, nil, 10 )
end

function atoi( string )
    return ffi.C.atoi( string )
end

function ffi_open( ffi_reqid, path, flags, mode )
    local output = ffi.C.open( path, atoi( flags ), strtoul( mode ) )
    mp.commandv( "script-message", "jpdb-ffi", ffi_reqid, output )
end

function ffi_close( ffi_reqid, fp )
    local output = ffi.C.close( atoi( fp ) )
    mp.commandv( "script-message", "jpdb-ffi", ffi_reqid, output )
end

function ffi_ftruncate( ffi_reqid, fp, length )
    local output = ffi.C.ftruncate( atoi( fp ), strtoul( length ) )
    mp.commandv( "script-message", "jpdb-ffi", ffi_reqid, output )
end

function ffi_mmap( ffi_reqid, length, protection, flags, fp, offset )
    local output = ffi.C.mmap( nil, strtoul( length ), atoi( protection ), atoi( flags ), atoi( fp ), strtoul( offset ) )
    output = tostring( ffi.cast( "intptr_t", output ) )
    mp.commandv( "script-message", "jpdb-ffi", ffi_reqid, output )
end

function ffi_shm_open( ffi_reqid, name, flags, mode )
    local output = ffi.C.shm_open( name, atoi( flags ), atoi( mode ) )
    mp.commandv( "script-message", "jpdb-ffi", ffi_reqid, output )
end

function ffi_shm_unlink( ffi_reqid, name )
    local output = ffi.C.shm_unlink( name )
    mp.commandv( "script-message", "jpdb-ffi", ffi_reqid, output )
end

function ffi_munmap( ffi_reqid, pointer, length )
    local output = ffi.C.munmap( ffi.cast( "void *", strtoul( pointer, nil, 10 ) ), strtoul( length ) )
    mp.commandv( "script-message", "jpdb-ffi", ffi_reqid, output )
end

function ffi_open_file_mapping( ffi_reqid, access, inherit_handle, name )
    local output = ffi.C.OpenFileMappingA( strtoul( access ), strtoul( inherit_handle ), name )
    output = tostring( ffi.cast( "intptr_t", output ) )
    mp.commandv( "script-message", "jpdb-ffi", ffi_reqid, output )
end

function ffi_map_view_of_file( ffi_reqid, handle, access, file_offset_hi, file_offset_lo, size )
    local output = ffi.C.MapViewOfFile( ffi.cast( "void *", strtoul( handle, nil, 10 ) ), strtoul( access ), strtoul( file_offset_hi ), strtoul( file_offset_lo ), strtoul( size ) )
    output = tostring( ffi.cast( "intptr_t", output ) )
    mp.commandv( "script-message", "jpdb-ffi", ffi_reqid, output )
end

mp.register_script_message( "jpdb-ffi-open", ffi_open )
mp.register_script_message( "jpdb-ffi-close", ffi_close )
mp.register_script_message( "jpdb-ffi-ftruncate", ffi_ftruncate )
mp.register_script_message( "jpdb-ffi-mmap", ffi_mmap )
mp.register_script_message( "jpdb-ffi-munmap", ffi_munmap )
mp.register_script_message( "jpdb-ffi-shm_open", ffi_shm_open )
mp.register_script_message( "jpdb-ffi-shm_unlink", ffi_shm_unlink )
mp.register_script_message( "jpdb-ffi-OpenFileMappingA", ffi_open_file_mapping )
mp.register_script_message( "jpdb-ffi-MapViewOfFile", ffi_map_view_of_file )

function on_mouse_left( data )
    if data.event == "down" then
        mp.commandv( "script-message", "jpdb-mouse-left-press" )
    elseif data.event == "up" then
        mp.commandv( "script-message", "jpdb-mouse-left-release" )
    end
end

function on_mouse_right( data )
    if data.event == "down" then
        mp.commandv( "script-message", "jpdb-mouse-right-press" )
    elseif data.event == "up" then
        mp.commandv( "script-message", "jpdb-mouse-right-release" )
    end
end

local is_initialized = false
local base_path = nil

if ffi.os == "Windows" then
    local Shell32 = ffi.load( "Shell32" )
    local Ole32 = ffi.load( "Ole32" )
    local guid = ffi.new( "GUID", {0x3EB685DB, 0x65F9, 0x4CF6, {0xA0, 0x3A, 0xE3, 0xEF, 0x65, 0x72, 0x9F, 0x3D}} )
    local buffer_wide = ffi.new( "unsigned short *[1]" )
    local buffer_utf8 = ffi.new( "char[260]" )
    local result = Shell32.SHGetKnownFolderPath( guid, 0, nil, buffer_wide )
    if result ~= 0 then
        mp.msg.error( "SHGetKnownFolderPath failed" )
        return
    end
    ffi.C.WideCharToMultiByte( 65001, 0, buffer_wide[0], -1, buffer_utf8, 260, ffi.cast( "const char *", 0 ), nil )
    Ole32.CoTaskMemFree( buffer_wide[0] )
    local app_data_path = ffi.string( buffer_utf8 )
    base_path = utils.join_path( app_data_path, "jpdb-mpv-plugin" ) .. "\\"
elseif ffi.os == "Linux" then
    base_path = utils.join_path( os.getenv( "HOME" ), ".local/share/jpdb-mpv-plugin" ) .. "/"
elseif ffi.os == "OSX" then
    base_path = utils.join_path( os.getenv( "HOME" ), "Library/Application Support/jpdb-mpv-plugin" ) .. "/"
end

function initialize()
    if is_initialized == true then
        return
    end
    is_initialized = true

    mp.msg.info( "Initializing..." )

    local exe_path = os.getenv( "JPDB_MPV_EXECUTABLE" )
    if exe_path == nil then
        if ffi.os == "Windows" then
            exe_path = base_path .. "jpdb-mpv-plugin.exe"
        else
            exe_path = base_path .. "jpdb-mpv-plugin"
        end
    end

    local ipc_path = mp.get_property( "input-ipc-server" )
    local should_clean_ipc = false
    if ipc_path == nil or ipc_path == "" then
        if ffi.os == "Windows" then
            ipc_path = "\\\\.\\pipe\\mpv-jpdb-" .. mp.get_property( "pid" )
        else
            ipc_path = "/tmp/mpv-jpdb-" .. mp.get_property( "pid" )
        end
        mp.set_property( "input-ipc-server", ipc_path )
        should_clean_ipc = true
    end

    mp.add_key_binding( "MBTN_LEFT", "jpdb-mouse-left", on_mouse_left, {complex = true} )
    mp.add_key_binding( "MBTN_RIGHT", "jpdb-mouse-right", on_mouse_right, {complex = true} )

    if os.getenv( "JPDB_MPV_DO_NOT_LAUNCH_EXECUTABLE" ) == "1" then
        return
    end

    local args = {exe_path, "plugin"}
    if should_clean_ipc then
        table.insert( args, "--clean-ipc" )
    end
    table.insert( args, ipc_path )
    mp.command_native({
        name = "subprocess",
        playback_only = false,
        detach = true,
        args = args
    })
end

if has_ffi then
    local autostart_path = base_path .. "autostart.flag"
    local fp = io.open( autostart_path, "r" )
    local should_autostart = false
    if fp then
        fp:close()
        should_autostart = true
    end

    local env_force_autostart = os.getenv( "JPDB_MPV_FORCE_AUTOSTART" )
    if env_force_autostart == "1" then
        should_autostart = true
    elseif env_force_autostart == "0" then
        should_autostart = false
    end

    if should_autostart then
        mp.register_event( "file-loaded", initialize )
    else
        mp.add_key_binding( "F10", "jpdb-mpv-initialize", initialize )
    end

else
    mp.msg.error( "Your copy of mpv was compiled without luajit support; the jpdb plugin will not work!" )
    mp.osd_message( "Your copy of mpv was compiled without luajit support; the jpdb plugin will not work!", 5 )
end
