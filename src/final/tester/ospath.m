function path = ospath(linuxpath)
s = filesep;
path = strrep(linuxpath,'/',s);