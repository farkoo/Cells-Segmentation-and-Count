# Cells-Segmentation-and-Count

Cell counting is any of various methods for the counting or similar quantification of cells in the life sciences, including medical diagnosis and treatment. It is an important subset of cytometry, with applications in research and clinical practice. For example, the complete blood count can help a physician to determine why a patient feels unwell and what to do to help. Cell counts within liquid media (such as blood, plasma, lymph, or laboratory rinsate) are usually expressed as a number of cells per unit of volume, thus expressing a concentration (for example, 5,000 cells per milliliter).


This program is implemented to count the number of cells in the image. The cells are also labeled and the area and average brightness level are calculated for each cell.

## Input:

<p align=center>
<img src="https://github.com/farkoo/Cells-Segmentation-and-Count/blob/master/Cells.jpg">
</p>

## Methods, challenges, solutions
For cell segmentation, we can use thresholding methods to convert a RGB or grayscale image to a black-and-white image, but the challenge with this method is that it makes a mistake in counting cells that are too close.

**Q4_a.m**
<p align=center>
<img src="https://github.com/farkoo/Cells-Segmentation-and-Count/blob/master/Diagram1.png">
</p>

<hr>

**MY_bwlabel.m**
<p align=center>
<img src="https://github.com/farkoo/Cells-Segmentation-and-Count/blob/master/Diagram2.png">
</p>

## Segmentation Result
<p align=center>
<img src="https://github.com/farkoo/Cells-Segmentation-and-Count/blob/master/Result.png">
</p>

### Calculate area and average brightness level
In the previous section, we mentioned that the cells are labeled, that is, the brightness level of the first cell is equal to one, and the brightness level of the second cell is equal to two, and so on. We know there are no more than 255 cells in each image.

To calculate the cell area of a binary mask based on the cell label number, the sum of the pixels of this mask is equal to the desired cell area.

To calculate the average brightness level of the image, multiply the binary mask obtained in the previous step by the primary image and obtain the average brightness level of the secondary image.
