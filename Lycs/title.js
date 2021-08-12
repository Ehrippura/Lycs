var getTitle = function() {

    var metas = Array.from(document.getElementsByTagName("meta"));
    var meta = metas.filter(m => m.getAttribute("property") == "og:title")[0];

    if (meta) {
        return meta.content;
    }
    return ""
}

getTitle()
