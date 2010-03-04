var Base = new Class({

  initialize: function() {
    this.watchTitleTogglers();
    this.watchTaskCheckboxes();
  },
  
  watchTaskCheckboxes: function() {

    Event.include({
      hideTaskInputs: function(input) {
        input.form.send();
        input.parent().hide();
        input.parent().parent().next('span.actions').hide();
        input.parent().next('label').addClass('clicked');
      }
    });
    
    $$(".simple_form.task span.boolean input").each( function(input) { 
      input.onClick(function(event) {
        event.hideTaskInputs(input);
      });
    });
    
    $$("span.save").each( function(span) { span.hide(); });
    
  },
  
  watchTitleTogglers: function() {
    
    $$("div.toggle").each(function(div) { div.hide(); });
    
    $$("h3.toggler").each(function(h3) {
      
      h3.insert(new Element('span'), 'top');
      
      if ( h3.hasClass('open') ) {
        h3.select('span')[0].update('&#9660;');
        h3.next('.toggle').show();
      }
      else {
        h3.select('span')[0].update('&#9654;');
      };
      
      h3.onClick(function() {
        if ( this.hasClass('open') ) {
          this.select('span')[0].update('&#9654;');
        }
        else {
           
           this.select('span')[0].update('&#9660;');
        };
        
        this.next('.toggle').toggle('slide',{ duration:100 });
        this.toggleClass('open');
      });
    });
  }
  
});

document.onReady(function() {
  new Base().initialize;
});
