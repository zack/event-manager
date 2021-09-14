//= require flatpickr

window.onload = function() {
  const el = document.getElementById('event_datetime');
  flatpickr(el, {
    enableTime:      true,
    altInput:        true,
    minDate:         "today",
    altFormat:       "F j, Y at h:i K",
    dateFormat:      "Y-m-d H:i",
    defaultHour:     18,
    defaultMinute:   30,
    minuteIncrement: 30
  });
};
