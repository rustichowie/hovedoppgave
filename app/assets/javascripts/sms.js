//Kjør med kommandoen: casperjs test sms.coffee --num="phonenumber" --text="textmessage"


//Sjekker om nummer og text er med i kjøringen
if(!casper.cli.has('num') || !casper.cli.has('text')){
casper.echo("Legg til --num=97177229 --text='sms-beskjed'").exit();
}

//setter userAgent(browser og maskin)
casper.userAgent('Mozilla/5.0 (Macintosh; Intel Mac OS X)');

//Starter casperJS, går til talkmore.no
casper.start('https://www.talkmore.no/',function(){
  this.viewport(1024, 768);
  
  //logger inn
  this.fill('form#loginform', {
        'username':   '97177229',
        'password':   'ed4m'
    }, true);
  this.click('form#loginform input[type="submit"]');
});

//Går til siden får sending av sms
casper.then(function(){

  this.test.assertTextExists('Send SMS', 'Fant linken');
  this.clickLabel('Send SMS', 'a');
});
  
//fyller ut felt med nummer og text, sender sms
casper.then(function(){

  this.page.switchToChildFrame(0);
  this.fill('form#ContactListForm', {
    'contact_list__phone_number_manual': casper.cli.get('num')
  	}, true);
  this.click('div#addButton a');
  this.sendKeys('form#ContactListForm textarea#sms_templates__message', casper.cli.get('text'));
  this.page.switchToParentFrame();
  this.click('div.button_green a');
});

casper.run();