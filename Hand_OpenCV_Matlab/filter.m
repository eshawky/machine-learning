
[x,map] = gifread('hand.ppm');
[r,g,b] = ind2rgb(x,map);

[filtmap,I,Rg,By,hue,saturation,MAD] = skinfilt(r,g,b);
imshow(x), title('Original Image'), colormap(map);


for row=1:size(x,1),
for column=1:size(x,2),
	if filtmap(row,column)==0
		x(row,column)=1;
	end
end
end

figure
imshow(x), title('Skin Filter Result'), colormap(map);

%colormap(gray)
%gifwrite((filtmap*255)+1,colormap,'M25.gif')