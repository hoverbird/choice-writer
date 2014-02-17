$(function() {
  // $('.dialog-line-character').typeahead({
  //   name: 'characters',
  //   remote: '/characters.json'
  // });

  // $('.dialog-line-tags').typeahead({
  //   name: 'tags',
  //   remote: '/tags.json'
  // });

  $('.dialog-lines').on('click', '.section-divider', function(event) {
    var $divider = $(event.target)
    var $el = $divider.prev();
    var $nextEl = $divider.next();

    $.ajax({
      url: '/new_line',
      method: 'POST',
      data: {
        character: $el.find('.dialog-line-character').val(),
        previous_line_id: $el.data('line-id'),
        scene: $el.data('scene')
      },
      success: function(html) {
        $newLine = $(html);
        $divider.remove();
        $el.after($newLine);
        $newLine.find('.dialog-line-display-character').click();
        $nextEl.data('previous-line-id', $newLine.data('line-id'));
        $nextEl.find('input.dialog-line-text').trigger('blur') // total hack, should use real event system
      }
    });
  })

  $('.replace-text').on("click", function(event) {
    event.preventDefault();
    var $el = $(event.target).parents('.replace-text');
    $el.addClass('editable');
    $el.find('.display').focus();
  });

  $('.replace-text').on("blur", "input", function(event) {
    event.preventDefault();

    var $el = $(event.target.parentElement);
    var $swapForm = $el.find('.replace-text');
    var $textInput = $el.find('input');

    $swapForm.removeClass('editable');
    $el.find('.display').text($textInput.val());

    var $dialogLine = $textInput.parents('.dialog-line');
    var onSuccess = function(html) {
      $dialogLine.replaceWith(html);
    };

    $.ajax({
      url: '/update',
      method: "POST",
      success: onSuccess,
      data: $dialogLine.find("input").serialize()
    });
  });
});