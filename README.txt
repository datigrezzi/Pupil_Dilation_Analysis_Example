In this folder there is an R script (pupil_analysis_example.R) and a sample data set in CSV format (pupil_data_sample.csv). If you open the R script the working directory in R should be set directly to the containing folder.

The data set contains binocular pupil data and some experiment-related logs (block number, trial number, cue and event). This data was collected while doing a variation of the Posner task. The baseline segment is set to include data when participants were presented with a fixation cross, before the cue appeared. The pupil segment ("target" in the example) is when the target appeared, or when participants realized that a cue was valid or invalid.

Please note that in the sample data final metrics are in negative because the cue and target stimuli were brighter than the fixation cross and therefore, when subtracting pupil diameter during baseline, the result is negative.

Please feel free to contact me if you have any questions using the form at this link: https://datigrezzi.com/contact/