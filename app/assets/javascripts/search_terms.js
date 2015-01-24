var AutoSearch = {
  highlightText: function(text, $node) {
    $node = $node.find('a').length ? $node.find('a') : $node
    var searchText = $.trim(text).toLowerCase(), currentNode = $node.get(0).lastChild, matchIndex, newTextNode, newSpanNode;
    while ((matchIndex = currentNode.data.toLowerCase().indexOf(searchText)) >= 0) {
      newTextNode = currentNode.splitText(matchIndex);
      currentNode = newTextNode.splitText(searchText.length);
      newSpanNode = document.createElement("span");
      newSpanNode.className = "highlight";
      currentNode.parentNode.insertBefore(newSpanNode, currentNode);
      newSpanNode.appendChild(newTextNode);
    }
  },

  //Function that renders individual item in autosearch
  renderItem: function(ul, item) {
    if (item.industry) {
      var $element = $('<div class="parent">');
      $element.text(item.industry.name).append(
        $("<a>", { class: 'margin-10', href: '/businesses/' +  item.id, 'data-id': item.id })
          .append($('<img>', { class: 'logo', src: 'http://functionv.com/wp-content/uploads/2014/03/SmallBusinessIcon.png'}))
          .append(item.name + '(Business)')
      );
    } else {
      var $element = $("<a>", { href: '/industries/' +  item.id, 'data-id': item.id }).text(item.name + '(Industry)');
    }
    AutoSearch.highlightText(this.term, $element);
    return $("<li>").append($element).appendTo(ul);
  },

  //make ajax call to fetch data
  remoteSearch: function(request, response) {
    $.ajax({
      url: "api/v1/search_terms/fetch_data",
      dataType: "json",
      data: {
        query: request.term
      }
    }).success(function(data) {
        response(data.results);
    }).error(function(){
        response([]);
    });
  },

  //autofill box on focus
  autoFillValue: function(event, ui) {
    event.preventDefault();
    $(this).val(ui.item.name);
    $('[data-id]').removeClass('hover');
    $('[data-id="' + ui.item.id + '"').addClass('hover');
  },

  initialize: function() {
    var _this = this;
    $( "#search" ).autocomplete({
      source: function(request, response) {
        _this.remoteSearch(request, response)
      },
      focus: function (event, ui) {
        _this.autoFillValue(event, ui)
      },
    }).data("ui-autocomplete")._renderItem = _this.renderItem;
  }
}

$(function() {
  AutoSearch.initialize();    
});