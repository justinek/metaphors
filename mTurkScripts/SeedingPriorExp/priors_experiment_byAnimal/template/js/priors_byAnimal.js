  function addDeterminer(word) {
    var vowels = ['a', 'e', 'i', 'o', 'u'];
    if (vowels.indexOf(word.charAt(0)) >= 0) {
      return 'an ' + word;
    } else {
      return 'a ' + word;
    }
  }

  function properArray(array) {
    for (var i=0; i < array.length; i++) {
      if (typeof array[i] == "undefined") {
        return false;
      }
      
    }
    return true;
  }

  function make_slides(f) {
    var   slides = {};

    slides.i0 = slide({
     name : "i0",
     start: function() {
      exp.startT = Date.now();
    }
  });

    slides.instructions = slide({
      name : "instructions",
      button : function() {
        exp.go(); //use exp.go() if and only if there is no "present" data.
      }
    });

    slides.single_trial = slide({
      name: "single_trial",
      start: function() {
        $(".err").hide();
        $(".display_condition").html("You are in " + exp.condition + ".");
      },
      button : function() {
        response = $("#text_response").val();
        if (response.length == 0) {
          $(".err").show();
        } else {
          exp.data_trials.push({
            "trial_type" : "single_trial",
            "response" : response
          });
          exp.go(); //make sure this is at the *end*, after you log your data
        }
      },
    });

    slides.one_slider = slide({
      name : "one_slider",

      /* trial information for this block
       (the variable 'stim' will change between each of these values,
        and for each of these, present_handle will be run.) */
  present : [
  {subject: "dog", object: "ball"},
  {subject: "cat", object: "windowsill"},
  {subject: "bird", object: "shiny object"},
  ],

      //this gets run only at the beginning of the block
      present_handle : function(stim) {
        $(".err").hide();

        this.stim = stim; //I like to store this information in the slide so I can record it later.


        $(".prompt").html(stim.subject + "s like " + stim.object + "s.");
        this.init_sliders();
        exp.sliderPost = null; //erase current slider value
      },

      button : function() {
        if (exp.sliderPost == null) {
          $(".err").show();
        } else {
          this.log_responses();

          /* use _stream.apply(this); if and only if there is
          "present" data. (and only *after* responses are logged) */
          _stream.apply(this);
        }
      },

      init_sliders : function() {
        utils.make_slider("#single_slider", function(event, ui) {
          exp.sliderPost = ui.value;
        });
      },

      log_responses : function() {
        exp.data_trials.push({
          "trial_type" : "one_slider",
          "response" : exp.sliderPost
        });
      }
    });

  slides.multi_slider = slide({
    name : "multi_slider",
    present : _.shuffle(_.shuffle([
      {"animalID": 1, "animal": "ant", "features": ["funny","industrious","busy","agile","quiet","fast","sleek","small","smart"], "numFeatures":9}, 
      {"animalID": 2, "animal": "whale", "features": ["cute","lazy","hard","big","proud","fast","playful","majestic","loyal","slow","fierce","strong","friendly"], "numFeatures":13}, 
      {"animalID": 3, "animal": "bird", "features": ["fast","small","industrious","agile","quiet","sleek"], "numFeatures":6}, 
      {"animalID": 4, "animal": "elephant", "features": ["hairy","cute","lazy","hard","big","proud","fast","playful","majestic","loyal","slow","fierce","striped","strong","friendly"], "numFeatures":15}, 
      {"animalID": 5, "animal": "panda", "features": ["cute","big","lazy","hard","playful","loyal","majestic","friendly"], "numFeatures":8}, 
      {"animalID": 6, "animal": "monkey", "features": ["funny","industrious","busy","cute","lazy","agile","quiet","fast","sleek","playful","loyal","dumb","small","loud","friendly","smart","happy"], "numFeatures":17}, 
      {"animalID": 7, "animal": "penguin", "features": ["funny","cute","lazy","playful","loyal","loud","friendly","smart"], "numFeatures":8}, 
      {"animalID": 8, "animal": "giraffe", "features": ["tall","long","slithery","strong","fast"], "numFeatures":5}, 
      {"animalID": 9, "animal": "cheetah", "features": ["funny","industrious","cute","lazy","agile","quiet","fast","sleek","playful","loyal","dumb","small","friendly","smart"], "numFeatures":14}, 
      {"animalID": 10, "animal": "turtle", "features": ["hairy","lazy","slow","big","hard","fast","majestic","strong"], "numFeatures":8}, 
      {"animalID": 11, "animal": "lion", "features": ["hairy","proud","big","hard","fast","fierce","majestic","striped","strong"], "numFeatures":9}, 
      {"animalID": 12, "animal": "rabbit", "features": ["fast","cute","lazy","agile","sleek","playful","loyal","friendly"], "numFeatures":8}, 
      {"animalID": 13, "animal": "mouse", "features": ["funny","industrious","busy","agile","quiet","fast","sleek","small","smart"], "numFeatures":9}, 
      {"animalID": 14, "animal": "beaver", "features": ["small","industrious","funny","busy","quiet","smart"], "numFeatures":6}, 
      {"animalID": 15, "animal": "horse", "features": ["hairy","lazy","proud","big","hard","fast","slithery","slow","long","fierce","tall","striped","strong","majestic"], "numFeatures":14}, 
      {"animalID": 16, "animal": "eagle", "features": ["big","majestic","hard","proud","fast","fierce","strong"], "numFeatures":7}, 
      {"animalID": 17, "animal": "jaguar", "features": ["funny","industrious","cute","lazy","agile","quiet","fast","sleek","playful","loyal","dumb","small","friendly","smart"], "numFeatures":14}, 
      {"animalID": 18, "animal": "armadillo", "features": ["big","hard","majestic","slow","strong"], "numFeatures":5}, 
      {"animalID": 19, "animal": "cat", "features": ["cute","lazy","funny","big","hard","fast","sleek","playful","loyal","dumb","agile","majestic","loud","friendly","smart","happy"], "numFeatures":16}, 
      {"animalID": 20, "animal": "dog", "features": ["cute","lazy","funny","big","hard","fast","sleek","playful","loyal","agile","majestic","loud","friendly","smart","happy"], "numFeatures":15}, 
      {"animalID": 21, "animal": "kitten", "features": ["cute","lazy","funny","big","hard","fast","sleek","playful","loyal","agile","majestic","loud","friendly","smart"], "numFeatures":14}, 
      {"animalID": 22, "animal": "hyena", "features": ["funny","lazy","cute","playful","loyal","loud","friendly","smart","happy"], "numFeatures":9}, 
      {"animalID": 23, "animal": "dolphin", "features": ["funny","smart","lazy","cute","loyal","loud","friendly","happy"], "numFeatures":8}, 
      {"animalID": 24, "animal": "snake", "features": ["tall","long","slithery","strong","fast"], "numFeatures":5}, 
      {"animalID": 25, "animal": "deer", "features": ["fast","agile","funny","lazy","cute","fast","sleek","dumb","smart"], "numFeatures":9}, 
      {"animalID": 26, "animal": "sloth", "features": ["slow","strong","hairy","lazy","big","hard","fast"], "numFeatures":7}, 
      {"animalID": 27, "animal": "gorilla", "features": ["hairy","lazy","slow","big","hard","fast","fierce","striped","strong"], "numFeatures":9}, 
      {"animalID": 28, "animal": "bear", "features": ["hairy","lazy","slow","big","hard","fast","fierce","striped","strong"], "numFeatures":9}, 
      {"animalID": 29, "animal": "tiger", "features": ["fierce","strong","hairy","big","hard","fast","striped"], "numFeatures":7}, 
      ]).slice(0,10).concat([{"animalID": 30, "animal": "man", "features": ["cute","hard","sleek","playful","slithery","dumb","long","majestic","funny","industrious","busy","agile","fast","friendly","smart","happy","hairy","lazy","big","slow","fierce","striped","strong","proud","quiet","loyal","small","tall","loud"], "numFeatures":29}])), 
  present_handle : function(stim) {
    $(".err").hide();
        this.stim = stim; //FRED: allows you to access stim in helpers

  /*
        this.sentence_types = _.shuffle(["generic", "negation", "always", "sometimes", "usually"]);
        var sentences = {
          "generic": stim.critter + " have " + stim.property + ".",
          "negation": stim.critter + " do not have " + stim.property + ".",
          "always": stim.critter + " always have " + stim.property + ".",
          "sometimes": stim.critter + " sometimes have " + stim.property + ".",
          "usually": stim.critter + " usually have " + stim.property + "."
        };
        */

        this.n_sliders = stim.numFeatures;
        $(".slider_row").remove();
        this.animalID = stim.animalID;
        this.animal = stim.animal;
        this.features = _.shuffle(stim.features);
        $("#animal").html(this.animal);

        for (var i=0; i<this.n_sliders; i++) {
          var sentence = "How " + this.features[i] + " is the " + this.animal + "?";
          $("#multi_slider_table").append('<tr class="slider_row"><td class="slider_target" id="sentence' + i + '">' + sentence + '</td><td colspan="2"><div id="slider' + i + '" class="slider">-------[ ]--------</div></td></tr>');
          utils.match_row_height("#multi_slider_table", ".slider_target");
        }

        this.init_sliders(this.features);
        exp.sliderPost = [];
      },

      button : function() {
        if (exp.sliderPost.length < this.n_sliders || !properArray(exp.sliderPost)) {
          $(".err").show();
        } else {
          this.log_responses();
          _stream.apply(this); //use _stream.apply(this); if and only if there is "present" data.
        }
      },

      init_sliders : function(sentence_types) {
        for (var i=0; i<sentence_types.length; i++) {
          var sentence_type = sentence_types[i];
          utils.make_slider("#slider" + i, this.make_slider_callback(i));
        }
      },
      make_slider_callback : function(i) {
        return function(event, ui) {
          exp.sliderPost[i] = ui.value;
        };
      },
      log_responses : function() {
        for (var i=0; i<this.features.length; i++) {
          var feature = this.features[i];
          exp.data_trials.push({
            "trial_type" : "multi_slider",
            "animalID" : this.animalID,
            "animal" : this.animal,
            "feature" : feature,
            "response" : exp.sliderPost[i]
          });
        }
      },
    });

  slides.vertical_sliders = slide({
    name : "vertical_sliders",
    present : _.shuffle([
    {
      "bins" : [
      {
        "min" : 0,
        "max" : 10
      },
      {
        "min" : 10,
        "max" : 20
      },
      {
        "min" : 20,
        "max" : 30
      },
      {
        "min" : 30,
        "max" : 40
      },
      {
        "min" : 40,
        "max" : 50
      },
      {
        "min" : 50,
        "max" : 60
      }
      ],
      "question": "How tall is tall?"
    }
    ]),
    present_handle : function(stim) {
      $(".err").hide();
      this.stim = stim;

      $("#vertical_question").html(stim.question);

      var bin_labels = "<td></td>";
      var sliders_and_top_label = "<td class='thin'>likely</td>";
      for (var i=0; i<stim.bins.length; i++) {
        bin_labels += "<td class='bin_label'>" + stim.bins[i].min + " - " + stim.bins[i].max + "</td>";
        sliders_and_top_label += "<td rowspan='3'><div id='vslider" + i + "' class='vertical_slider'>|</div></td>";
      }
      $("#sliders_and_top_label").html(sliders_and_top_label);
      $("#bin_labels").html(bin_labels);

      this.init_sliders(stim);
      exp.sliderPost = [];
    },

    button : function() {
      if (exp.sliderPost.length < this.n_sliders) {
        $(".err").show();
      } else {
        this.log_responses();
          _stream.apply(this); //use _stream.apply(this); if and only if there is "present" data.
        }
      },

      init_sliders : function(stim) {
        for (var i=0; i<stim.bins.length; i++) {
          utils.make_slider("#vslider" + i, this.make_slider_callback(i), "vertical");
        }
      },
      make_slider_callback : function(i) {
        return function(event, ui) {
          exp.sliderPost[i] = ui.value;
        };
      },
      log_responses : function() {
        for (var i=0; i<this.stim.bins.length; i++) {
          exp.data_trials.push({
            "trial_type" : "vertical_slider",
            "question" : this.stim.question,
            "response" : exp.sliderPost[i],
            "min" : this.stim.bins[i].min,
            "max" : this.stim.bins[i].max
          });
        }
      },
    });

  slides.subj_info =  slide({
    name : "subj_info",
    submit : function(e){
        //if (e.preventDefault) e.preventDefault(); // I don't know what this means.
        exp.subj_data = {
          language : $("#language").val(),
          enjoyment : $("#enjoyment").val(),
          asses : $('input[name="assess"]:checked').val(),
          age : $("#age").val(),
          gender : $("#gender").val(),
          education : $("#education").val(),
          comments : $("#comments").val(),
        };
        exp.go(); //use exp.go() if and only if there is no "present" data.
      }
    });

  slides.thanks = slide({
    name : "thanks",
    start : function() {
      exp.data= {
        "trials" : exp.data_trials,
        "catch_trials" : exp.catch_trials,
        "system" : exp.system,
        "condition" : exp.condition,
        "subject_information" : exp.subj_data,
        "time_in_minutes" : (Date.now() - exp.startT)/60000
      };
      setTimeout(function() {turk.submit(exp.data);}, 1000);
    }
  });

  return slides;
}

  /// init ///
  function init() {
    exp.trials = [];
    exp.catch_trials = [];
    exp.condition = _.sample(["condition 1", "condition 2"]); //can randomize between subject conditions here
    exp.system = {
      Browser : BrowserDetect.browser,
      OS : BrowserDetect.OS,
      screenH: screen.height,
      screenUH: exp.height,
      screenW: screen.width,
      screenUW: exp.width
    };
    //blocks of the experiment:
    exp.structure=["i0", "instructions", "multi_slider", 'subj_info', 'thanks'];
    
    exp.data_trials = [];
    //make corresponding slides:
    exp.slides = make_slides(exp);

    exp.nQs = utils.get_exp_length(); //this does not work if there are stacks of stims (but does work for an experiment with this structure)
                      //relies on structure and slides being defined

    $('.slide').hide(); //hide everything

    //make sure turkers have accepted HIT (or you're not in mturk)
    $("#start_button").click(function() {
      if (turk.previewMode) {
        $("#mustaccept").show();
      } else {
        $("#start_button").click(function() {$("#mustaccept").show();});
        exp.go();
      }
    });

    exp.go(); //show first slide
  }