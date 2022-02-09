// Define global variables.
var temperature = 0.1;
var generate_door_probabilities = 0;
var generate_goal_probabilities = 1;
var choice_index = 3;

// Apply the softmax transformation.
var softmax = function(U, temperature) {
  var Z = map(function(x){return Math.pow(Math.E, temperature*x)}, U);
  return map(function(x){return x/sum(Z)}, Z);
} 

// Compute the posterior over utility functions conditioned on choice history.
var compute_posterior = function(choice_histogram, temperature) {
  return Infer({method: 'enumerate'}, function() {
    // Sample a utility vector from a uniform prior.
    var U = repeat(choice_histogram.length,
                   function(){return uniformDraw(_.range(100))});

    // Convert the utility vector into choice probabilities.
    var choice_probabilities = softmax(U, temperature);

    // Condition distribution on choice history.
    var choice_distribution = Multinomial({ps: choice_probabilities,
                                           n: sum(choice_histogram)});
    observe(choice_distribution, choice_histogram);
    return U;
  });
}

// Generate the action probabilities over doors based on choice history.
if (generate_door_probabilities) {
  // Set up a dictionary containing choice histories for two- and three-door
  // maps.
  var door_choices = {
    'two_doors': [
      [7, 2],
      [2, 7],
      [5, 4]
    ],
    'three_doors': [
      [6, 2, 1],
      [1, 6, 2],
      [2, 1, 6]
    ]
  }

  // Compute the posteriors over doors conditioned on choice histories.
  var door_posterior = {
    'two_doors': [
      compute_posterior(door_choices['two_doors'][0], temperature),
      compute_posterior(door_choices['two_doors'][1], temperature),
      compute_posterior(door_choices['two_doors'][2], temperature)
    ],
    'three_doors': [
      compute_posterior(door_choices['three_doors'][0], temperature),
      compute_posterior(door_choices['three_doors'][1], temperature),
      compute_posterior(door_choices['three_doors'][2], temperature)
    ]
  }

  // Compute the expected value of the posteriors over doors.
  var door_expected_value = {
    'two_doors': [
      mapN(function(n){return expectation(door_posterior['two_doors'][0],
        function(x){return x[n]})}, door_choices['two_doors'][0].length),
      mapN(function(n){return expectation(door_posterior['two_doors'][1],
        function(x){return x[n]})}, door_choices['two_doors'][1].length),
      mapN(function(n){return expectation(door_posterior['two_doors'][2],
        function(x){return x[n]})}, door_choices['two_doors'][2].length)
    ],
    'three_doors': [
      mapN(function(n){return expectation(door_posterior['three_doors'][0],
        function(x){return x[n]})}, door_choices['three_doors'][0].length),
      mapN(function(n){return expectation(door_posterior['three_doors'][1],
        function(x){return x[n]})}, door_choices['three_doors'][1].length),
      mapN(function(n){return expectation(door_posterior['three_doors'][2],
        function(x){return x[n]})}, door_choices['three_doors'][2].length)
    ]
  }

  // Compute the action probabilities over doors.
  var door_probabilities = {
    'two_doors': [
      softmax(door_expected_value['two_doors'][0], temperature),
      softmax(door_expected_value['two_doors'][1], temperature),
      softmax(door_expected_value['two_doors'][2], temperature)
    ],
    'three_doors': [
      softmax(door_expected_value['three_doors'][0], temperature),
      softmax(door_expected_value['three_doors'][1], temperature),
      softmax(door_expected_value['three_doors'][2], temperature)
    ]
  };

  // Display the action probabilities over doors.
  display(door_probabilities);
}

// Generate the action probabilities over goals based on choice history.
if (generate_goal_probabilities) {
  // Set up an array containing a set of choice histories over goals.
  var goal_choices = [
    [6, 2, 1],
    [1, 6, 2],
    [2, 1, 6],
    [3, 3, 3]
  ];

  // Compute the posterior over goals conditioned on the selected choice
  // histories.
  var goal_posterior = compute_posterior(goal_choices[choice_index],
    temperature)

  // Sample from the goal posterior.
  var samples = repeat(10,
    function(){return display(sample(goal_posterior))});

  // Pipe the output to a text file using the following command:
  // `webppl prior_update.js > goals_$GOAL_CHOICES.csv`
  // where $GOAL_CHOICES is one of the arrays of goal choices.

  // Strip the spaces and brackets using the following commands:
  // `sed -i goals_$GOAL_CHOICES.csv 's/\ //g'` (remove spaces)
  // `sed -i goals_$GOAL_CHOICES.csv 's/\[//g'` (remove opening bracket)
  // `sed -i goals_$GOAL_CHOICES.csv 's/\]//g'` (remove closing bracket)

  // Finally, place this file in the following directory:
  // `$PROJECT_PATH/data/experiment_4/model/predictions/Manhattan`
  // where $PROJECT_PATH is the path to the project directory.
}
