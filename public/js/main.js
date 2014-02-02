$(function() {
  $('.dialog-line-character').typeahead({
    name: 'characters',
    remote: '/characters.json'
  });

  $('.dialog-line-tags').typeahead({
    name: 'tags',
    remote: '/tags.json'
  });

  $('.dialog-lines').on('click', '.insert-line', function(event) {
    var $el = $(event.target).parents('.dialog-line');
    var $nextEl = $el.next('.dialog-line');

    $.ajax({
      url: '/new_line',
      method: 'POST',
      data: {
        previous_line_id: $el.data('line-id'),
        scene: $el.data('scene')
      },
      success: function(html) {
        $newLine = $(html);
        $el.after($newLine);
        $nextEl.data('previous-line-id', $newLine.data('line-id'));
        $nextEl.find('input.dialog-line-text').trigger('blur') // total hack, should use real event system
      }
    });
  })

  $('.dialog-fields').on("click", '.dialog-line-display-text', function(event) {
    var $el = $(event.target).parents('.dialog-line');
    var $textInput = $el.find('.dialog-line-text');
    var $textDisplay = $el.find('.dialog-line-display-text');

    $textDisplay.hide();
    $textInput.removeClass('invisible').show().focus();
  });

  $('.dialog-fields').on("blur", '.dialog-line input', function(event) {
    event.preventDefault();
    var $input = $(event.target);
    var $display = $input.next();

    // Should animate this
    $display.text($input.val()).show();
    $input.addClass('invisible');

    var $el = $input.parents('.dialog-line');

    var text = $el.find('.dialog-line-text').val();
    var tags = $el.find('.dialog-line-tags').val();
    var character = $el.find('.dialog-line-character').val();
    var previousLineId = $el.data('previous-line-id');

    var scene = $el.data('scene');
    var lineId = $el.data('line-id');

    var onSuccess = function(html) {
      $el.replaceWith(html);
    };

    $.ajax({
      url: '/update',
      method: "POST",
      success: onSuccess,
      data: {
        "id": lineId,
        "text": text,
        "tags": tags,
        "character": character,
        "previous_line_id": previousLineId,
        "scene": scene
      }
    });
  });
});