//= require flatpickr

window.onload = function() {
  const start_el = document.getElementById('special_event_datetime');
  const end_el = document.getElementById('special_event_datetime_end');

  const shared_opts = {
    enableTime:      true,
    altInput:        true,
    minDate:         "today",
    altFormat:       "F j, Y at h:i K",
    dateFormat:      "Y-m-d H:i",
  };

  const end_opts = {
    ...shared_opts,
    minDate: "today",
    defaultHour: 23,
    defaultMinute: 59,
  }

  const end_flatpickr = flatpickr(end_el, end_opts);

  const start_opts = {
    ...shared_opts,
    defaultHour:     18,
    defaultMinute:   30,
    minuteIncrement: 30,
    onChange: () => {
      end_flatpickr.setDate(start_el.value.split(" ")[0] + " 23:59");
      end_flatpickr.set("minDate", start_el.value.split(" ")[0]);
    },
  };

  const start_flatpickr = flatpickr(start_el, start_opts);

  if (start_el.value) {
      end_flatpickr.set("minDate", start_el.value.split(" ")[0]);
  }
};
