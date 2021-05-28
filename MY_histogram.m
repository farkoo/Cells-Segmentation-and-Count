function hist_ = MY_histogram(im)

    hist_ = zeros(256, 1);
    for i = 1 : size(im, 1)
        for j = 1 : size(im, 2)
            if(im(i, j) == 255)
                hist_(256) = hist_(256) + 1;
            elseif(im(i, j) == 254)
                hist_(255) = hist_(255) + 1;
            else
                hist_(im(i,j)+1) = hist_(im(i, j)+1) + 1;
            end
        end
    end
    
end