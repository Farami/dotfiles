function gc --wraps='git clean -xdf' --description 'alias gc git clean -xdf'
  git clean -xdf $argv; 
end
