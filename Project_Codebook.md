Codebook for Week 4 Peer-Graded Assignment for Getting and Cleaning Data Course

by John Kenneth Velonta

The first step was to load the features from the features.txt file, which contains the names of the features/variables that we will be utilizing in the assignment.

The next step was to convert the previously loaded features to a vector for further use.

Next, I loaded the subject data for the test and training datasets. Then I used rbind to merge the test and train subjects.

Next, I loaded the activities file, merged them through rbind, and changed from numeric to verbose activities through a left_join.

Next, the test and training datasets were loaded and merged through rbind.

I used a combination of strsplit, rbind, and cbind, to separate each feature from each observation to different columns.

Then I had to deselect columns 1 and 2.

Then selected the columns representing the means and standard deviations with the use of grep. Any column name with mean or std on them were selected.

Then, for tidying the feature names, f were changed to frequency, t were changed to time, and the numbers parentheses were removed through sub.

I then merged the datasets, activities, and subjects through cbind.

The resulting merged dataframe was then grouped by subject and activity, and then summarized to get the mean for each grouping.

The resulting dataframe was then exported as a csv file through write_csv.
