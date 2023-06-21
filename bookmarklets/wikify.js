// Instructions:
// Copy this - without the comments - into the url of a bookmark, then use it
// Including the newlines should be fine - browser will remove them though so
// need to use /*comments*/ and such. Always use semicolons
javascript:
var date = new Date();
var dateString = new Date(
    date.getTime() - (date.getTimezoneOffset() * 60000 )
)
    .toISOString()
    .split("T")[0];
navigator.clipboard.writeText(dateString + " - " + "?" + " - " + document.title + " - " + window.location);

