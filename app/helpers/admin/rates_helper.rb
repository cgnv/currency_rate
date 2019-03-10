# frozen_string_literal: true

module Admin::RatesHelper
  def bootstrap_datetime_picker(form, attr, id)
    value = form.object.public_send(attr)&.strftime('%d.%m.%Y %H:%M')
    datetime = form.datetime_field attr, value: value, 'data-target': "##{id}",
                                         class: 'form-control datetimepicker-input'

    <<~HTML.html_safe
      <div class="input-group date" id="#{id}" data-target-input="nearest">
        #{datetime}
        <div class="input-group-append" data-target="##{id}" data-toggle="datetimepicker">
          <div class="input-group-text"><i class="fa fa-calendar"></i></div>
        </div>
      </div>
      <script>
        $(function () {
          $('##{id}').datetimepicker({ locale: 'ru' });
        });
      </script>
    HTML
  end
end
