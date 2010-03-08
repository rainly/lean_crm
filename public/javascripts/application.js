var Base = new Class({

  initialize: function() {
    this.watchTitleTogglers();
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
