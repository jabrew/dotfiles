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
var title = document.title;
var suffixes = [
    " - Google Docs",
];
for (const suffix of suffixes) {
    if (title.endsWith(suffix)) {
        title = title.substr(0, title.length - suffix.length);
    };
};
navigator.clipboard.writeText(dateString + " - " + "?" + " - " + title + " - " + window.location);

