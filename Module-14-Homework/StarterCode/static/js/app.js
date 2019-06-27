// from data.js
var tableData = data;
console.log(data);
var tbody = d3.select("tbody");


data.forEach((ufoSighting) => {
  var row = tbody.append("tr");
  Object.entries(ufoSighting).forEach(([key, value]) => {
  var cell = row.append("td");
  cell.text(value);
  });
});

//filter button for date
var submit = d3.select("#filter-btn");

submit.on("click", function() {
  d3.event.preventDefault();
  var inputDate = d3.select("#datetime").property("value");
  var inputCity = d3.select("#city").property("value");
  var inputState = d3.select("#state").property("value");
  var inputShape = d3.select("#shape").property("value");

  if(inputDate && !inputCity && !inputState && !inputShape) {
    filter(inputDate, 'datetime');
  } else if(!inputDate && inputCity && !inputState && !inputShape) {
    filter(inputCity, 'city');
  } else if(!inputDate && !inputCity && inputState && !inputShape) {
    filter(inputState, 'state');
  } else if(!inputDate && !inputCity && !inputState && inputShape) {
    filter(inputShape, 'shape');
  } else {
    alert("Please only enter 1 search criteria.")
  }
});

function filter(searchParam, column) {
  filteredData = tableData.filter(ufoSighting => ufoSighting[column] === searchParam.toLowerCase());
  console.log(filteredData);
  tbody.html("");
  if(filteredData.length !== 0){
    filteredData.forEach((filteredufoSighting) => {
      var row = tbody.append("tr");
      Object.entries(filteredufoSighting).forEach(([key, value]) => {
        var cell = row.append("td");
        cell.text(value);
      });
    });
  }
  else{
    console.log("Nothing");
    tbody.append("td").text("Information not available for the requested filter.\n Please enter something different.");
  };
};
