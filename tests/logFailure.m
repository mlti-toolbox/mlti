function logFailure(testCase, timestamp)
    filename = timestamp + ".mat";
    dirName = "failed_test_cases";
    if ~isfolder(dirName)
        mkdir(dirName);
    end
    filePath = fullfile(dirName, filename);
   
    if ~isfile(filePath)
        testData = testCase.TestData;
        stack = dbstack;
        testSeries = stack(2).file;
        save(filePath, "testData", "testSeries");
    end
end