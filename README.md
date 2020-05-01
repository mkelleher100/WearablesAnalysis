# WearablesAnalysis

run_analysis.R begins by reading the following data sets from the UCI HAR Dataset into :
1. activity_labels.txt
2. features.txt
3. X_test.txt
4. y_test.txt
5. subject_test.txt
6. X_train.txt
7. y_train.txt
8. subject_train.txt

The first level of processing merges the table, applies appropriate variable names, and adds descriptive activity names. This is stored in a data frame: data

The second level of processing extracts only the means and standard deviation variable. This is stored in a data frame: extractedData.

The final level of processing summarizes the average of each variable in the extracted data by Subject ID and Activity. This is stored in data frame: tidy

