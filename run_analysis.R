library(dplyr)
library(stringr)
#Read in Data Sets
actLab <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
features <- read.table("./data/UCI HAR Dataset/features.txt")

testX <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
testy <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
testSub <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

trainX <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
trainy <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
trainSub <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#Apply variable names to column names
testy <- rename(testy, "Activity" = V1)
trainy <- rename(trainy, "Activity" = V1)

testSub <- rename(testSub, "SubjectID" = V1)
trainSub <- rename(trainSub, "SubjectID" = V1)

testX <- setNames(testX,  features[,2])
trainX <- setNames(trainX,  features[,2])

#Map Activity Names to Factors
testy$Activity <- factor(testy$Activity)
levels(testy$Activity) <- actLab[, 2]

trainy$Activity <- factor(trainy$Activity)
levels(trainy$Activity) <- actLab[, 2]

#Merge Data Sets for test and train
testData <- cbind(testSub, testy, testX)
trainData <- cbind(trainSub, trainy, trainX)
data <- rbind(testData, trainData)

#Extract Means and Standard Deviations
mstd <-grep("mean\\()|std\\()", names(data))
extractedData <- data[, c(1, 2, mstd)]

#Set Subject ID to factors
extractedData$SubjectID <- as.factor(extractedData$SubjectID)

#Initialize Tidy Data Frame
tidy <- data.frame(NULL)
count <- 1
sepIDs <- split(extractedData, extractedData$SubjectID)

#Loop through IDs, then through activities.
for(i in seq_along(sepIDs)) {
        sepActs <- split(sepIDs[[i]], sepIDs[[i]]$Activity)
        for(j in seq_along(sepActs)) {
                #FInd column means and append them to the tidy data fram
                avgs <- colMeans(sepActs[[j]][3:dim(sepActs[[j]])[2]])
                newRow <- cbind(SubjectID = i, Activity = j,t(data.frame(avgs)))
                tidy <- rbind(tidy, newRow)
                rownames(tidy)[[count]] <- count
                count = count + 1
        }
}

#Map Activity Names to Factors and Turn Subject IDs to factors
tidy$Activity <- factor(tidy$Activity)
levels(tidy$Activity) <- actLab[, 2]

tidy$Activity <- factor(tidy$Activity)
levels(tidy$Activity) <- actLab[, 2]
tidy$SubjectID <- as.factor(tidy$SubjectID)



