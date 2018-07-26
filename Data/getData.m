clear all, close all, clc;

x = [0:999];
Len = length(x);
x = dec2hex(x);

fp = fopen('data.txt','w');
if fp > 0
	for k = 1:Len
		fprintf(fp, '%s\n', x(k,:));
	end
	fclose(fp);
else
	Error('open file filed.')
end
