This work was carried out as an assignment for the NOVA course on deep learning for remote sensing.

# Optimising annotation effort for object detection with deep learning

Deep convolutional neural networks (CNETs) have been demonstrated as effective models for object detection in images. However, time and resource costs of annotating vast supplies of training and testing data still slow the development of effective tools. Here I explore a potential solution for minimising the required quantity of annotated data whilst still maximising the performance gains of CNETs. 

Recent work with large language models (LLM) has found that guiding models through typical thinking strategies that humans employ boosts performance considerably [1](https://doi.org/10.48550/arXiv.2305.10601). This work, inspired by how humans think through tasks, has developed a prompting strategy coined tree of thoughts, where the LLM is asked to break a task into a chain of subtasks, to generate multiple solutions to each subtask, and to select only a few of the best solutions at each stage before continuing. Here I suggest a similar framework for CNETs used for object detection, again inspired by how humans think, and specifically how humans teach other humans to annotate data. 

When training a group of people to annotate data the naive approach would be to iterate through a randomly selected training dataset, where many of the images and objects are nearly identical. Eventually, given enough time, unique images and objects will arise allowing the trainees to experience a wide variety of situations they may encounter. An alternative approach would be to collect unique images or objects prior to training to demonstrate all possible situations with the minimum number of images. The latter approach is more frequently used when training people to minimise time costs. However, despite this approach with humans, the annotation effort for training CNETs still follows the former naive approach. 

To systematically collect unique images I develop a method that summarises grid cells by their textural indicides using summary measures of grey scale cooccurrence matrices (described in detail in [2](https://doi.org/10.1109/TSMC.1973.4309314)), including the correlation, contrast, energy and dissimilarity of the red and green bands. I then take a sample of cells that are spatially balanced across the distribution of spectral indices to maximise the uniqueness of each image. This subset is then used for model training. The balanced subset model is then compared with random subset model of the same size and a total model that utilises all grid cells in model training. Here I assess if the same, or greater model performance can be achieved with reduced annotation effort.

## Methods

The spectral indices and subsetting was carried out using the [julia](https://julialang.org/) programming language. After the traning data has been split into grid cells the usage is simple. Clone this repository and run 

    ´
    include(src/textural_indicies.jl)
    inputpath = pwd() * "data/train/cells/"
    outputpath = pwd * "data/train/balanced_subset/"
    n = 200
    textural_subset(inputpath, outputpath, n)
    ´

where ´inputpath´ is the directory to the grid cells you wish to subset, ´outputpath´ is where you want to copy the subset data to, and ´n´ is the number of cells you wish to subset. In the demo we used 75% of the data resulting in 290 samples for ´n´, though this will largely depend on the complexity of the problem and the resouces that are avalible. The function has no output and only copies files to the new directory.

If this workflow is being used to minimise annotation effort, the annotation work can now be done on the subset files. For this demonstration, however, all cells have been annotated prior to subsetting to allow comparison of the subset and total models. 

Here I use the yolo nano pretrained CNET for object detection. The model is trained separately on the balanced subset, the random subset and the total dataset using default parameters. The code to prepare and train the model is in a collection of jupyter notebooks found in 'src/yolo'. 

## Results

The results for the balanced subset model showed improved accuracy when compared to a random subset model of the same size. However, the accuracy did not exceed that of the full dataset. More testing is needed to decide if this could be a useful tool.