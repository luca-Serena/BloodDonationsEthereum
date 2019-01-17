App = {
  web3Provider: null,
  contracts: {},
  account: '0x0',

  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {
    if (typeof web3 !== 'undefined') {
      // If a web3 instance is already provided by Meta Mask.
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      // Specify default instance if no web3 instance provided
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
      web3 = new Web3(App.web3Provider);
    }
    return App.initContract();
  },

  initContract: function() {
    $.getJSON("DonationClinic.json", function(clinic) {
      // Instantiate a new truffle contract from the artifact
      App.contracts.DonationClinic = TruffleContract(clinic);
      // Connect provider to interact with contract
      App.contracts.DonationClinic.setProvider(App.web3Provider);

      return App.render();
    });
  },

  render: function() {
    var clinicInstance;
    var loader = $("#loader");
    var content = $("#content");
    // Load account data
    web3.eth.getCoinbase(function(err, account) {
      if (err === null) {
        App.account = account;
        $("#hospitalName").html("Blood Donation - Account : " + account);// + nome); 
        $("#hospitalName").css("font-size", "24px");
      }
    });
    
    // Load contract data
    App.contracts.DonationClinic.deployed().then(function(instance) {
         clinicInstance = instance; 
         var isHospital = App.account == 0x67025Ad0dAa5c0f2724ac15024Ec0F5Db9eBC6C1;

       if (isHospital){
           $("#dispensing").show();
           $("#collecting").show();
           $("#joining").hide();
           $("#booking").hide();
       } else {
           $("#dispensing").hide();
           $("#collecting").hide();
           $("#joining").show();
           $("#booking").show();
       }

      $("#buttonDispense").click(function(){
            var amount = $("#amountDispense").val();
            var bloodType = $("#bloodSelect").val();
            clinicInstance.dispense(bloodType, amount);
         } 
      ); 
  
      $("#buttonCollect").click(function(){
            var amount = $("#amountCollect").val();
            var donor = $("#reservations").val();
            clinicInstance.collect(donor,amount);
         }
      );

      $("#buttonJoin").click(function(){
            var bloodType = $("#bloodSelectJoin").val();
            $('#bloodSelectJoin').prop('disabled',true).css('opacity',0.5);
            $('#buttonJoin').prop('disabled',true).css('opacity',0.5);
            
            clinicInstance.join(bloodType);
         }
      );

     $("#buttonBook").click(function(){
            clinicInstance.book();
            var option = document.createElement("option");
         }
      );

     return clinicInstance.getTokens(App.account);
  }).then(function(tokens){
        if (tokens > 0){
            $("#accountAddress").html("You own " + tokens + " tokens");
        }
    return clinicInstance.getDonorsLength();
      }).then(function(total){
      for (var index = 0; index < total; index++) {
           clinicInstance.donors(index).then(function(booker){
           if (booker[3] == true){
              var opt = document.createElement("option");
              opt.text = booker[1];
              $("#reservations")[0].add(opt);
            } 
         }); 
      }
      var dispTable = $('#editAvailability');
      dispTable.empty();
      for (var i = 0; i < 8; i++) {
          clinicInstance.bloodArray(i).then(function(bld){
            var nome = bld[0];
            var  ml = bld[1];
            var option = document.createElement("option");
            var option2 = document.createElement("option");
            option.text = nome;
            option2.text = nome;
           $("#bloodSelect")[0].add(option);
           $("#bloodSelectJoin")[0].add(option2);
            dispTable.append ("<tr><td>" + nome + "</td><td>" + ml + "</td></tr>");
          });
      } 
      loader.hide();
      content.show(); 
 /*   }).catch(function(error) {
      console.warn(error);
    */});
  }
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
