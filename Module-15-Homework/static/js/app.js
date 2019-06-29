function buildMetadata(sample) {
  console.log("Build metadata"); 

  // @TODO: Complete the following function that builds the metadata panel

  // Use `d3.json` to fetch the metadata for a sample
    // Use d3 to select the panel with id of `#sample-metadata`
    var metadata = d3.select("#sample-metadata");

    // Use `.html("") to clear any existing metadata
    metadata.html("");

    // Use `Object.entries` to add each key and value pair to the panel
    // Hint: Inside the loop, you will need to use d3 to append new
    // tags for each key-value in the metadata.
    var url = `/metadata/${sample}`;

    d3.json(url).then((response) => {
      Object.entries(response).forEach(d => {
        metadata.append('p').text(`${d[0]}: ${d[1]}`);
      });
    });

}

function buildCharts(sample) {
  console.log("Build new chart");

  // @TODO: Use `d3.json` to fetch the sample data for the plots
  pie_div = document.getElementById('pie');

  var url = `/samples/${sample}`;
  d3.json(url).then((response) => {
    var trace1 = {
      x: response['otu_ids'],
      y: response['sample_values'],
      hovertext: response['otu_labels'],
      hoverinfo: 'hovertext',
      mode: 'markers',
      marker: {
        size: response['sample_values'],
        color: response['otu_ids']
      }
    };
    // @TODO: Build a Bubble Chart using the sample data
    var data = [trace1];

    var layout = {
      title: 'Bubble Chart',
      showlegend: false,
      height: 600,
      width: 1200,
      xaxis: {title: "OTU ID"},
      yaxis: {title: "Values"}
    };

    Plotly.newPlot('bubble', data, layout);

    // BONUS: Build the Gauge Chart
    console.log(sample)
    buildGauge(sample);

    // @TODO: Build a Pie Chart
    // HINT: You will need to use slice() to grab the top 10 sample_values,
    // otu_ids, and labels (10 each). 
 
    var trace2 = {
      labels: response['otu_ids'].slice(0,10),
      values: response['sample_values'].slice(0,10),
      hovertext: response['otu_labels'].slice(0,10),
      hoverinfo: 'hovertext',
      type: "pie"
    };
 
    var data = [trace2];
    var layout = {
      title: "Pie Chart",
    };

    Plotly.newPlot('pie', data, layout);
    
  });
}

function init() {
  // Grab a reference to the dropdown select element
  var selector = d3.select("#selDataset");

  // Use the list of sample names to populate the select options
  d3.json("/names").then((sampleNames) => {
    sampleNames.forEach((sample) => {
      selector
        .append("option")
        .text(sample)
        .property("value", sample);
    });

    // Use the first sample from the list to build the initial plots
    const firstSample = sampleNames[0];
    buildCharts(firstSample);
    buildMetadata(firstSample);
  });
}

function optionChanged(newSample) {
  // Fetch new data each time a new sample is selected
  buildCharts(newSample);
  buildMetadata(newSample);
}

// Initialize the dashboard
init();
