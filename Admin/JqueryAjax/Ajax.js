function AjaxCall(url, data, Onsuccess) {
    $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: url,
        data: data,
        dataType: "json",
        success: Onsuccess,
    });
}

function AjaxCall(url, data, Onsuccess, OnbeforeSend) {
    $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: url,
        data: data,
        dataType: "json",
        beforeSend: OnbeforeSend,
        success: Onsuccess,
    });
}

function AjaxCall(Type, url, data, Onsuccess, OnbeforeSend) {
    $.ajax({
        type: Type,
        contentType: "application/json; charset=utf-8",
        url: url,
        data: data,
        dataType: "json",
        beforeSend: OnbeforeSend,
        success: Onsuccess,
    });
}


function AjaxCall(url, data, successMethod, OnbeforeSend, OnComplete) {
    $.ajax({
        type: "POST",
        contentType: "application/json; charset=utf-8",
        url: url,
        data: data,
        dataType: "json",
        beforeSend: OnbeforeSend,
        success: successMethod,
        complete: OnComplete
    });
}
