### custom functions to identify outliers
# function to return index of all values that are above or below N Standard Deviations from the mean
stdOutlierIdx <- function(x, nSD = 3, na.rm=T){
	idx <- rep(FALSE, length(x))
	idx[x < (mean(x, na.rm=na.rm) - (sd(x, na.rm=na.rm) * nSD)) | x > (mean(x, na.rm=na.rm) + (sd(x, na.rm=na.rm) * nSD))] <- TRUE
	return(idx)
}
# function to return the index of all values that are above or below a static threshold
threshOutlierIdx <- function(x, min=0, max=6){
	idx <- rep(FALSE, length(x))
	idx[x < min | x > max] <- TRUE
	return(idx)
}

### start processing
# read in a participant's pupil dataset
pupilData <- read.table("pupil_data_sample.csv", sep=';', dec='.',header=T)
# check dataset variables
head(pupilData)
# create dataset for saving averages
pupilAvg <- data.frame()
# for each trial
for(i in 1:max(pupilData$trial)){
	# select trial data to remove outliers for each trial separately
	thisTrial <- pupilData[pupilData$trial==i,]
	thisTrial$pupilLeft[stdOutlierIdx(thisTrial$pupilLeft) | threshOutlierIdx(thisTrial$pupilLeft)] <- NA
	thisTrial$pupilRight[stdOutlierIdx(thisTrial$pupilRight) | threshOutlierIdx(thisTrial$pupilRight)] <- NA
	# interpolate
	library(zoo)
	thisTrial$pupilLeft <- na.approx(thisTrial$pupilLeft, na.rm=F)
	thisTrial$pupilRight <- na.approx(thisTrial$pupilRight, na.rm=F)
	# average pupils
	thisTrial$pupils <- rowMeans(cbind(thisTrial$pupilLeft, thisTrial$pupilRight))
	# get baseline mean
	baseline <- mean(thisTrial$pupils[thisTrial$event=='baseline'], na.rm=T)
	# correct target pupil
	correctedPupil <- thisTrial$pupils[thisTrial$event=='target'] - baseline
	# calculate corrected pupil mean
	correctedPupilAvg <- mean(correctedPupil, na.rm=T)
	# save to dataset (trial, cue and corrected pupil)
	pupilAvg[i, 1] <- thisTrial$trial[1] # trial number
	pupilAvg[i, 2] <- thisTrial$cue[1] # cue validity
	pupilAvg[i, 3] <- correctedPupilAvg # corrected pupil average during target
}
# rename pupilAvg dataset variables 
names(pupilAvg) <- c("trial",'validity','pupil')
# calculate average for each validity condition
aggregate(data=pupilAvg, pupil~validity, FUN=mean)