function optImage = AHE(numTiles, imagePath)
    % Read the image from some path
    Image = imread(imagePath);
    
    % Print the size of the input image
%     sprintf('Size of your input image: %d, %d',size(Image))
    
    % Preprocessing: divide the image into tiles
    [numTiles,Image,dimTile] = PreProcessInput(numTiles,Image);
    
    % Tile mapping
    tileMappings = makeTileMappings(numTiles,Image,dimTile);
    
    % AHE
    optImage = makeAHEImage(Image, tileMappings, numTiles, dimTile);
    
    % Print two sizes
%     sprintf('Size of the input image after padding: %d, %d',size(Image))
%     sprintf('Size of each tile: %d, %d',dimTile)
end

% =========================================================================
% Preprocessing
% =========================================================================
function [numTiles,Image,dimTile] = PreProcessInput(numTiles,Image)
    % Size of the input image
    dimInput = size(Image);
    dimTile = dimInput ./ numTiles;
    % check if the size is reasonable
    if any(dimTile < 1)
        error(message('Too small to split', num2str(numTiles)))
    end
    % Check if the image needs to be padded
    % Padding occurs if any dimension of a single tile is an odd number
    % and/or when image dimensions are not divisible by the selected number
    % of tiles
    
    % If the row/column is divisible
    rowDiv = mod(dimInput(1),numTiles(1)) == 0;
    colDiv  = mod(dimInput(2),numTiles(2)) == 0;
    
    % If the row/column is even
    if rowDiv && colDiv
        rowEven = mod(dimTile(1),2) == 0;
        colEven = mod(dimTile(2),2) == 0;  
    end
    
    % If any of the four boolean value is FALSE
    if ~(rowDiv && colDiv && rowEven && colEven)
        padRow = 0;
        padCol = 0;
        
        % Row is not divisible
        if ~rowDiv
            rowTileDim = floor(dimI(1)/numTiles(1)) + 1;
            padRow = rowTileDim*numTiles(1) - dimI(1);
        else
            rowTileDim = dimI(1)/numTiles(1);
        end
            
        % Column is not divisible
        if ~colDiv
            colTileDim = floor(dimI(2)/numTiles(2)) + 1;
            padCol = colTileDim*numTiles(2) - dimI(2);
        else
            colTileDim = dimI(2)/numTiles(2);
        end
        
        % check if tile dimensions are even numbers
        % not even => dim + 1
        rowEven = mod(rowTileDim,2) == 0;
        colEven = mod(colTileDim,2) == 0;
        if ~rowEven
            padRow = padRow + numTiles(1);
        end
        if ~colEven
            padCol = padCol + numTiles(2);
        end
        
        % Padding
        padRowPre  = floor(padRow/2);
        padRowPost = ceil(padRow/2);
        padColPre  = floor(padCol/2);
        padColPost = ceil(padCol/2);
        
        % Symmetrical Padding
        Image = padarray(Image,[padRowPre padColPre],'symmetric','pre');
        Image = padarray(Image,[padRowPost padColPost],'symmetric','post');        
    end
    
    % Recalculate the image size after padding
    dimInput = size(Image);
    dimTile = dimInput ./ numTiles;  
end

% =========================================================================
% TileMappings
% =========================================================================
function tileMappings = makeTileMappings(numTiles, Image, dimTile)
    tileMappings = cell(numTiles);
    
    imgCol = 1;
    for col = 1:numTiles(2)
        imgRow = 1;
        for row = 1:numTiles(1)
            tile = Image(imgRow:imgRow+dimTile(1)-1, imgCol:imgCol+dimTile(2)-1);
            tileHist = GetImageHist(tile);
            tileMapping = PixelMapping(tileHist,dimTile);
            tileMappings{row,col} = tileMapping;
            imgRow = imgRow + dimTile(1);
        end
        imgCol = imgCol + dimTile(2);
    end
%     sprintf('Tile Mappings size is: %d, %d',size(tileMappings))           
end

% =========================================================================
% Make AHE images
% =========================================================================
function optImage = makeAHEImage(Image, tileMappings, numTiles, dimTile)
    % Initialize the output image
    optImage = Image;
    optImage(:) = 0;
    
    % Interpolation
    imgTileRow = 1;
    for k = 1:numTiles(1) + 1
        % The top row
        if k == 1
            imgTileNumRows = dimTile(1)/2;
            mapTileRows = [1, 1];
        else
            % The bottom row
            if k == numTiles(1) + 1  
                imgTileNumRows = dimTile(1)/2;
                mapTileRows = [numTiles(1), numTiles(1)];
            % Default values
            else 
                imgTileNumRows = dimTile(1); 
                mapTileRows = [k-1, k]; % [upperRow lowerRow]
            end
        end
        
        imgTileCol = 1;
        for l = 1:numTiles(2) + 1
            % The left column
            if l == 1
                imgTileNumCols = dimTile(2)/2;
                mapTileCols = [1, 1];
            else
                % The right column
                if l == numTiles(2) + 1
                    imgTileNumCols = dimTile(2)/2;
                    mapTileCols = [numTiles(2), numTiles(2)];
                % Default values
                else
                    imgTileNumCols = dimTile(2);
                    mapTileCols = [l-1, l]; % [left right]
                end
            end
            ulMapTile = tileMappings{mapTileRows(1), mapTileCols(1)};
            urMapTile = tileMappings{mapTileRows(1), mapTileCols(2)};
            blMapTile = tileMappings{mapTileRows(2), mapTileCols(1)};
            brMapTile = tileMappings{mapTileRows(2), mapTileCols(2)};
            
            normFactor = imgTileNumRows * imgTileNumCols;
            subImage = Image(imgTileRow:imgTileRow+imgTileNumRows-1,imgTileCol:imgTileCol+imgTileNumCols-1);
            sImage = uint8(zeros(size(subImage)));
            
            for i = 0:imgTileNumCols-1  %x
                inverseI = imgTileNumCols - i;  %1-x
                for j = 0:imgTileNumRows-1  %y
                    inverseJ = imgTileNumRows - j;  %1-y
                    val = subImage(j+1,i+1);
                    
                     sImage(j+1, i+1) = (inverseJ*(inverseI*ulMapTile(val+1) + ...
                        i*urMapTile(val+1))+ j*(inverseI*blMapTile(val+1) +...
                        i*brMapTile(val+1)))/normFactor;
                end
            end            
            optImage(imgTileRow:imgTileRow+imgTileNumRows-1,imgTileCol:imgTileCol+imgTileNumCols-1) = sImage;
            imgTileCol = imgTileCol + imgTileNumCols;
        end
        imgTileRow = imgTileRow + imgTileNumRows;
    end
end
% =========================================================================
% Pixel Mapping
% =========================================================================
function optPixelValue = PixelMapping(inHist, dimImage)
    frequency = inHist/(dimImage(1)*dimImage(2));
    accumulation = zeros(1, 256);
    accumulation(1, 1) = frequency(1, 1);
    for i = 2:256
        accumulation(1,i) = accumulation(1,i-1) + frequency(1,i);
    end
    optPixelValue = floor(accumulation * 255);
end
% =========================================================================
% Get image histogram
% =========================================================================
function optGrayHist = GetImageHist(inGrayImage)
    % Input => Gray image
    % Output => The histogram of the gray image
    [rows, columns] = size(inGrayImage);
    optGrayHist = zeros(1, 256);
    for i = 1:rows
        for j = 1:columns
            optGrayHist(inGrayImage(i,j)+1) = optGrayHist(inGrayImage(i,j)+1) + 1;
        end
    end
end