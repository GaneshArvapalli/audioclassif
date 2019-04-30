# Audio Classification on Gender

## Intro to Data Science for BME 2019
### Ganesh Arvapalli
### Johns Hopkins University

#### Overview

[Shiny App Link](https://ganesh-arvapalli.shinyapps.io/audioclassif/)

[Presentation](https://docs.google.com/presentation/d/1tIIDQlvHgTi3TzhHWPvTA08pGONDpQzKkPwrH3-1RP0/edit?usp=sharing)

This app takes in voice audio data to classify whether someone is male or female. The dataset used for training can be found [here](https://www.kaggle.com/primaryobjects/voicegender). The features used all depend on the frequency distribution of the audio sample.

To run an example with all plots, run `voice-gender.R` and uncomment the plots you would like to view. They are the same ones that appear in the full Shiny app.

The full shiny app can be run from `voiceGenderPage.R`. Open it in Chrome on `localhost:3038` to view the app running locally.

#### Algorithm

Voice data features were read in from a csv file and the dataset was split into training/testing (80%/20%). Labels were converted by using "male" as 1. An SVM classifier was trained and verified with an AUC generally above 0.9.

To plot the results of classifying with the SVM, PCA was used to reduce down to two dimensions. Color was added according to the predicted label.

In the Shiny app, voice audio input was transformed into a frequency distribution with weights at each frequency. The values were converted to be between 0 and 1 to maintain consistency with the training set by subtracting the min and dividing by the range of values.

After frequency transforming and scaling, the following features are calculated:

- meanFreq: Mean frequency
- sd: Standard deviation of frequency 
- median: Median frequency
- Q25: Frequency at 25th percentile
- Q75: Frequency at 75th percentile
- IQR: Interquartile range

These features, which were also used to classify the training data, were then sent to the svm, which predicted the gender based on a empirically determined threshold.


#### Requirements

The following R packages are required to run.

- `e1071`
- `kernlab`
- `ggplot2`
- `ggfortify`
- `ROCR`
- `shiny`
- `shinyearr`
  - Found at [https://github.com/nstrayer/shinyearr](https://github.com/nstrayer/shinyearr) and installed using `devtools::install_github("nstrayer/shinyearr")`.
- `tidyverse`
- `forcats`
- `Hmisc`