function testDates(daysBack,nodeIndex)

display("---------------------------")
queryDate = datetime('today','timezone','utc') - daysBack;
display("Days Back " + string(daysBack))
display("Query Date " +   string(queryDate))
display("Node Index " + string(nodeIndex))

end