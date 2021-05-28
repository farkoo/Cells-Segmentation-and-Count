function [count,im] = MY_bwlabel(img)

% Get dimensions
h = size(img,1);
w = size(img,2);

% Pad the image with a border of 1
% im = padImage(img, 1);
temp = zeros(h,1);
img = horzcat(temp, img);
img = horzcat(img, temp);
temp = zeros(1,w+2);
img = vertcat(temp, img);
img = vertcat(img, temp);
im = img;

% labels starts from 255 to 0
tag = 255;

% hashmap
hash = containers.Map;


for row = 2:h+1
    for col = 2:w+1
        
        % Current pixel is of interest - change 255 to 1 if it's binary.
        if im(row,col) == 1
          
            neighbours = [im(row,col-1) im(row-1,col-1) ...
                im(row-1,col) im(row-1,col+1)];

            % all neighbours are zero: new component
            if nnz(neighbours) == 0
                im(row,col) = tag; %give it a label
                tag = tag-1; %increment label

            % only one neighbour is non-zero
            elseif nnz(neighbours) == 1
                index = find(neighbours); %get index of non-zero neighbour
                im(row,col) = neighbours(index); %set current pixels to neighbour's label

            % more than one neighbour is non-zero - tricky part
            else
                % get non-zero indexes
                indices = find(neighbours);
                % set it to a label of the lowest number
                l = min(neighbours(indices));
                im(row,col) = l;

                % record equivalence classes
                for i = 1:length(indices) % loop over all non-zero neighbours
                    templ = neighbours(indices(i)); % get its label

                    s = int2str(l); % convert label to string cuz hashmap

                    if templ ~= l % we only look at differing labels - e.g. 2->2 is not helpful
                        if isKey(hash,s) % already in hashmap
                            hash(s) = unique([hash(s) templ]);
                        else
                            hash(s) = templ;
                        end
                    end
                end
                
            end
            
        end
        
    end
end 

% Handle equivalences: restructure hashmap so that no key is a value and no
% values is a key. Basically we don't want: 12->13 and 13->14-15. We want
% it like 12->14-15.
for k = keys(hash)
  if isKey(hash,k)
      thekey = k{1}; % curly braces for key
      array = hash(thekey);

      x=1;
      len = length(array);

      % loop over current value array
      while x <= len
          % current value at index x
          cur = array(x);

          % see if value is its own key. E.g. 12->13 and also 13->14-15. The value 13 is also a key somewhere else.
          if isKey(hash, int2str(cur)) % the key exists

              % get value array of that key
              array2 = hash(int2str(cur));

              % put all those values in current value array. Create 12->14-15
              array = [array array2];
              
              % update hashmap
              hash(thekey) = array;
              
              % update while loop stats
              x = 1; len = length(array);

              % remove this key
              remove(hash, int2str(cur));
          else
              x = x+1;
          end
      end
  end
end

% Create the inverse mapping, will be easier for re-labelling.
% Because now we have keys like: 15->13-12-9. We want 13->15, 12->15, 9->15.
newhash = containers.Map;
for k = keys(hash)
    varray = hash(k{1}); %values
    for i = 1:length(varray) %loop over values
        newhash(int2str(varray(i))) = str2num(k{1});
    end
end

% Remove padding from image
im = im(2:h+1, 2:w+1);


% Relabel whole image
for row = 1:h
    for col = 1:w
        p = im(row,col);
        if isKey(newhash,int2str(p))
            im(row,col) = newhash(int2str(p)); % set proper label
        end
    end
end

% Get number unique values - these will be the count of blobs.
count = length(unique(im))-1; % zero is not a label so: minus 1

