var j = 0;
var wrong_attempts = 0;

function make_slides(f) {
  var slides = {};

  slides.i0 = slide({
    name: "i0",
    start: function() {
        exp.startT = Date.now();
        $(".first_fail").hide();
        $(".second_fail").hide();
    }
  });

  // Set up the introduction slides.
  for (var i = 0; i < 9; i++) {
    slides["introduction_" + i] = slide({
      name: "introduction_" + i,
      start: function() {},
      button: function() { exp.go(); }
    });
  }

  // Set up the catch trial slide.
  slides.catch_trial = slide({
    name: "catch_trial",
    start: function() {
      $(".catch_error").hide();

      exp.question = ["How many corners is each person walking to?",
                      "Do people always drop their cookie crumbs on their path to/from a corner?",
                      "Do people get to choose which door they enter through?",
                      "Do people leave the room out of the same door they entered or the door closest to them?",
                      "Can people move diagonally?",
                      "What color are the walls?"];

      $(".catch_slide").html(
        "<p>" + exp.question[0] + "</p>" +
        "<p>" +
        "<label><input type=\"radio\" name=\"question_0\" value=\"0\"/>1</label>" +
        "<label><input type=\"radio\" name=\"question_0\" value=\"1\"/>2</label>" + 
        "<label><input type=\"radio\" name=\"question_0\" value=\"2\"/>3</label>" +
        "<label><input type=\"radio\" name=\"question_0\" value=\"-1\"/>Not sure</label>" +
        "</p>" +
        "<p>" + exp.question[1] + "</p>" +
        "<p>" +
        "<label><input type=\"radio\" name=\"question_1\" value=\"0\"/>Yes</label>" +
        "<label><input type=\"radio\" name=\"question_1\" value=\"1\"/>No</label>" +
        "<label><input type=\"radio\" name=\"question_1\" value=\"-1\"/>Not sure</label>" +
        "</p>" +
        "<p>" + exp.question[2] + "</p>" +
        "<p>" +
        "<label><input type=\"radio\" name=\"question_2\" value=\"0\"/>Yes</label>" +
        "<label><input type=\"radio\" name=\"question_2\" value=\"1\"/>No</label>" +
        "<label><input type=\"radio\" name=\"question_2\" value=\"-1\"/>Not sure</label>" +
        "</p>" +
        "<p>" + exp.question[3] + "</p>" +
        "<p>" +
        "<label><input type=\"radio\" name=\"question_3\" value=\"0\"/>Same door</label>" +
        "<label><input type=\"radio\" name=\"question_3\" value=\"1\"/>Closest door</label>" +
        "<label><input type=\"radio\" name=\"question_3\" value=\"-1\"/>Not sure</label>" +
        "</p>" +
        "<p>" + exp.question[4] + "</p>" + 
        "<p>" +
        "<label><input type=\"radio\" name=\"question_4\" value=\"0\"/>Yes</label>" +
        "<label><input type=\"radio\" name=\"question_4\" value=\"1\"/>No</label>" + 
        "<label><input type=\"radio\" name=\"question_4\" value=\"-1\"/>Not sure</label>" +
        "</p>" +
        "<p>" + exp.question[5] + "</p>" +
        "<p>" +
        "<label><input type=\"radio\" name=\"question_5\" value=\"0\"/>White</label>" +
        "<label><input type=\"radio\" name=\"question_5\" value=\"1\"/>Gray</label>" +
        "<label><input type=\"radio\" name=\"question_5\" value=\"2\"/>Red</label>" +
        "<label><input type=\"radio\" name=\"question_5\" value=\"-1\"/>Not sure</label>" +
        "</p>");
    },
    button: function() {
      exp.target_0 = $("input[name='question_0']:checked").val();
      exp.target_1 = $("input[name='question_1']:checked").val();
      exp.target_2 = $("input[name='question_2']:checked").val();
      exp.target_3 = $("input[name='question_3']:checked").val();
      exp.target_4 = $("input[name='question_4']:checked").val();
      exp.target_5 = $("input[name='question_5']:checked").val();

      // Runs if the participant fails to answer every question.
      if ((exp.target_0 === undefined) || (exp.target_1 === undefined) || (exp.target_2 === undefined) ||
          (exp.target_3 === undefined) || (exp.target_4 === undefined) || (exp.target_5 === undefined)) {
          $(".catch_error").show();
      }

      // Runs if the participant answers any question incorrectly.
      else if ((exp.target_0 != "0") || (exp.target_1 != "0") || (exp.target_2 != "1") || 
               (exp.target_3 != "0") || (exp.target_4 != "1") || (exp.target_5 != "1")) {
        if (wrong_attempts == 1) { 
          exp.go(-9);
          $(".warning").hide();
          $(".first_fail").hide();
          $(".second_fail").show();
        }
        else {
          $(".catch_error").hide();
          wrong_attempts++;
          exp.go(-9);
          $(".bar").css('width', ((100/exp.nQs) + "%"));
          exp.phase = 2;
          $(".first_fail").show();
        }
      }
      else { exp.go(); }
    }
  });

  // Set up the forwarding slide.
  slides.forwarding = slide({
    name: "forwarding",
    start: function() {
      $(".forwarding_error_0").hide();
      $(".forwarding_error_1").hide();

      $(".forwarding_slide").html(
        "<p>" +
        "To access the task, please click on the link below. This link will open the task on a new tab/window " +
        "(depending on your browser settings). When you've reached the end of the task, you'll receive a code that " +
        "you need to paste in the box below in order to continue. <b>This code is not the code you submit to " +
        "MTurk.</b> After you enter the code and hit the Continue button, there will be one final slide with " +
        "demographic questions that help us understand your answers. You'll receive your MTurk code after that " +
        "slide." +
        "</p>" +
        "<p>" +
        "<a href=\"https://compdevlab.yale.edu/studies/lopez-brau/ImageInference/experiments/experiment_2/" +
        "empty-example/index.html\" target=\"_blank\">Click here to access the task.</a>" +
        "</p>" +
        "<p>" +
        "<label for=\"experiment_code\">" +
        "Enter your experiment code here:" +
        "</label>" +
        "<br>" +
        "<input type=\"text\" name=\"experiment_code\">" +
        "<br>" +
        "</p>");
    },
    button: function() {
      exp.experiment_code = $("input[name='experiment_code']").val();

      // Runs if a participant fails to enter an experiment code.
      if (exp.experiment_code === "") {
        $(".forwarding_error_1").hide();
        $(".forwarding_error_0").show();
      }

      // Runs if a participant enters an experiment code whose length is less than
      // the total number of trials.
      else if (exp.experiment_code.length !== 10) {
        $(".forwarding_error_0").hide();
        $(".forwarding_error_1").show();
      }
      else {
        exp.catch_trials.push({
          "question_0": exp.question[0],
          "target_0": exp.target_0,
          "question_1": exp.question[1],
          "target_1": exp.target_1,
          "question_2": exp.question[2],
          "target_2": exp.target_2,
          "question_3": exp.question[3],
          "target_3": exp.target_3,
          "question_4": exp.question[4],
          "target_4": exp.target_4,
          "question_5": exp.question[5],
          "target_5": exp.target_5,
          "wrong_attempts": wrong_attempts,
          "experiment_code": exp.experiment_code
        });
        exp.go();
      }
    }
  });

  slides.subj_info = slide({
    name: "subj_info",
    start: function() {},
    submit: function(e) {
      exp.subj_data = {
        "language": $("#language").val(),
        "enjoyment": $("#enjoyment").val(),
        "asses": $("input[name='assess']:checked").val(),
        "age": $("#age").val(),
        "gender": $("#gender").val(),
        "education": $("#education").val(),
        "problems": $("#problems").val(),
        "fairprice": $("#fairprice").val(),
        "comments": $("#comments").val()
      };
      exp.go();
    }
  });

  slides.thanks = slide({
    name: "thanks",
    start: function() {
      exp.data = {
        "catch_trials": exp.catch_trials,
        "system": exp.system,
        "subject_information": exp.subj_data,
        "time_in_minutes": (Date.now() - exp.startT) / 60000
      };
      // setTimeout(function() {turk.submit(exp.data);}, 1000);
      $(".end").html("<form name=\"SendData\" method=\"post\" action=\"end.php\">" +
        "<input type=\"hidden\" name=\"ExperimentResult\" value=\'" + 
        JSON.stringify(exp.data).replace(/'/g, "") + "\' />" + 
        "<button type=\"submit\">Submit</button>" +
        "</form>");
    }
  });

  return slides;
}

function init() {

  // Set up the payment amount and Unique Turker.
  exp.time = 15;
  $(".time").html(exp.time);
  $(".payment").html("$" + (exp.time/60*8.00).toPrecision(3));
  repeatWorker = false;
  (function() {
    var ut_id = "lopez-brau_06-18-2019_ImageInference";
    if (UTWorkerLimitReached(ut_id)) {
      $('.slide').empty();
      repeatWorker = true;
      alert("You have already completed the maximum number of HITs allowed by this requester. Please click " + 
        "'Return HIT' to avoid any impact on your approval rating.");
    }
  })();

  // Define the number of trials.
  exp.num_trials = 23;
  $(".num_trials").html(exp.num_trials);

  // Initialize an array to store the catch trial results.
  exp.catch_trials = [];
  
  // Get user system specs.
  exp.system = {
    Browser: BrowserDetect.browser,
    OS: BrowserDetect.OS,
    screenH: screen.height,
    screenUH: exp.height,
    screenW: screen.width,
    screenUW: exp.width
  };

  // Stitch together the blocks of the experiment.
  exp.structure = [
    "i0", 
    "introduction_0", 
    "introduction_1", 
    "introduction_2", 
    "introduction_3", 
    "introduction_4",
    "introduction_5", 
    "introduction_6", 
    "introduction_7", 
    "introduction_8", 
    "catch_trial",
    "forwarding",
    "subj_info",
    "thanks"
  ]; 
 
  // Make the slides (don't need to embed since we aren't using sliders).
  exp.slides = make_slides(exp);

  // Get the length of the experiment.
  exp.nQs = utils.get_exp_length();

  // Hide the slides.
  $(".slide").hide();

  // Make sure Turkers have accepted HIT (or you're not in MTurk).
  $("#start_button").click(function() {
    if (turk.previewMode) {
      $("#mustaccept").show();
    }
    else {
      $("#start_button").click(function() { $("#mustaccept").show(); });
      exp.go();
    }
  });

  // Launch the slides.
  exp.go();
}