#Run with casperjs test sms.coffee
casper.echo("Legg til --num=97177229 --text='sms-beskjed'").exit() unless casper.cli.has('num') and casper.cli.has('text')

casper.userAgent('Mozilla/5.0 (Macintosh; Intel Mac OS X)')
casper.start 'https://www.talkmore.no/', ->
  this.viewport(1024, 768)
  this.fill('form#loginform', {
        'username':   '97177229',
        'password':   'ed4m'
    }, true)
  this.click('form#loginform input[type="submit"]')

casper.then ->
  this.capture('a.png')
  this.test.assertTextExists('Send SMS', 'link found');
  this.clickLabel('Send SMS', 'a')

casper.then ->
  this.capture('b.png')
  this.page.switchToChildFrame(0)
  this.fill('form#ContactListForm', {
    'contact_list__phone_number_manual': casper.cli.get('num')
  }, true)
  this.click('div#addButton a')
  this.sendKeys('form#ContactListForm textarea#sms_templates__message', casper.cli.get('text'))
  this.page.switchToParentFrame()
  this.click('div.button_green a')

casper.then ->
  this.capture('c.png')

casper.run()