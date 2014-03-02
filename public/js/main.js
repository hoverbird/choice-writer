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
    var $divider = $(this);
    var $el = $divider.prev();
    var $nextEl = $divider.next();

    $.ajax({
      url: '/new_line',
      method: 'POST',
      data: $el.find("input").serialize(),
      success: function(html) {
        $newLine = $(html);
        $divider.remove();
        $el.after($newLine);
        $newLine.find('.dialog-line-display-character').click();
        $nextEl.data('previous-line-id', $newLine.data('line-id'));
        debugger
        $newLine.find('.card-body .replace-text .display').click()
      }
    });
  })

  $('.replace-text').on("click", function(event) {
    console.log("clicked", this)
    var $el = $(this);
    $el.addClass('editable');
    $el.find('input').focus();
  });

  $('.replace-text').on("blur", "input", function(event) {
    console.log("blurred", this)
    event.preventDefault();

    var $el = $(event.target.parentElement);
    var $swapForm = $el.find('.replace-text');
    var $textInput = $(this);

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
