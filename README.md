# Maximising the performance gained from annotation effort for object detection with deep learning

Deep convolutional neural networks (CNETs) have been demonstrated as effective models for object detection in images. However, time and resourse costs of annotating vast supplies of training and testing data still slow the development of effective tools. Here I explore a potential solution for minimising the required quantity of annotated data whilst still maximing the performance gains of CNETs. 

Recent work with large language models (LLM) has found that guiding models through typical thinking strategies that humans employ boosts performance considerably [2][2]. This work, inspired by how humans think through tasks, has developed a prompting strategy coined tree of thoughts, where the LLM is asked to break a task into a chain of subtasks, to generate multiple solutions to each subtask, and to select only a few of the best solutions at each stage before continuing. Here I suggest a similar framework for CNETs used for object detection, again inspired by how humans think, and specifically how humans teach other humans to annotate data. 

When training a group of people to annotate data the naive approach would be to iterate through a randomly selcted training dataset, where many of the images and objects are nearly identical. Eventually, given enough time, unique images and objects will arrise allowing the trainees to experience a vide variety of situations they may encounter. An alternative approach would be to collect unique images or objects prior to training to demonstrate all possible situations with the minimum number of images. The latter approach is more frequently used when training people to minimise time costs. However, despite this approach with humans, the annotation effort for training CNETs still follows the former naive approach. 

To systematically collect unique images I develop a method that summarises grid cells by their spectral indicides, including the mean and variance of red, green and blue pixel intensity. I then take a sample of cells that are spatially balanced across the distribution of spectral indicies to maximise the uniqueness of each image. This subset is then used for model traning. The subset model is then compared with a total model that utilises all grid cells in model training. Here I assess if the same, or greater model performance can be achieved with reduced annotation effort.

## Methods

The spectral indices and subsetting was carried out using the [julia](https://julialang.org/) programming language. After the traning data has been split into grid cells the usage is simple. Clone this repository and run 

    ´
    include(src/spectral_indicies.jl)
    path = "data/train/cells/
    n = 200
    subset_paths = subset_cells_balance_spectral_indicies(path, n)
    ´

where ´path´ is the directory to the grid cells you wish to subset, and ´n´ is the number of cells you wish to subset. A recommendation for ´n´ will be shown here, though this will largely depend on the complexity of the problem and the resouces that are avalible. The output of the function is a vector of paths to the subset cells. These can be coppied to a new directory with base julia functions:

    ´
    files = [splitdir(subset_path)[2] for subset_path in subset_paths]
    dst_folder = "data/train/subset/"

    cp(subset_paths, dst_folder .* files)
    ´

If this workflow is being used to minimuse annotation effort, the annotation work can now be done on the subset files. For this demonstration, however, all cells have been annotated prior to subsetting to allow comparison of the subset and total models. 

Here I use the yolo nano pretrained CNET for object detection. The model is trained twice separately on the subset and total dataset using default parameters. The code to prepare and train the model is in a collection of jupyter notebooks found in 'src/yolo'. 


## Results



## Bibliography
[1]: (https://doi.org/10.48550/arXiv.2305.10601)