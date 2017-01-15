var G_SHELVES = [];
var G_NOW_SHELf = 0;

function changeShelf(shelfID) {
  var shelf = G_SHELVES[shelfID];
  console.log(shelf);
  var shelf_id = "shelf" + shelf.shelf_id;
  $("#bookshelves").empty();
  $("#bookshelves").loadTemplate(
        "bookshelves-template.html",{
          /*
          "shelf_name" : shelf.shelf_name,
          "shelf_owner" : shelf.shelf_owner,
          "created_at" : shelf.created_at,
          */
          "bookshelf_id" : shelf_id
        },
        {append:false, async: false}
  );

  $("#shelf_name").text(shelf.shelf_name);
  $("#shelf_owner").text("created by " + shelf.shelf_owner);

  shelf.books.forEach(function(book){
    var book_id = "book" + book.book_id;
    $("#" + shelf_id + " .books").loadTemplate(
            "books-template.html",{
              "isbn" : book.isbn,
              "name" : book.name,
              "file_name" : book.file_name,
              "comment" : book.comment,
              "book_id" : book_id
            },
            {append:true, async: false}
    );
    //tagsの表示のため別テンプレート呼び出し
    /*
    book.tags.forEach(function(tag){
      $("#" + shelf_id + " .books #" + book_id).loadTemplate(
        "tags.template.html",{
              "tag" : tag
            },
            {append:true, async: false}
          );
    }); // tags
    */
  });   // books

  $(".col-book").click(function(evt) {
        setBookInfo(parseInt(evt.target.id.substr(4)));
        console.log(parseInt(evt.target.id.substr(4)));
        $("body").append('<div id="modal-bg"></div>');

        modalResize();

        $("#modal-bg, #modal-main").fadeIn("slow");

        $("#modal-bg").click(function(){
          $("#modal-bg, #modal-main").fadeOut("slow", function(){
            $("#modal-bg").remove();
          });
        });

        $(window).resize(modalResize);
        
        function modalResize(){
          var w = $(window).width();
          var h = $(window).height();

          var contw = $("#modal-main").outerWidth();
          var conth = $("#modal-main").outerHeight();

          $("#modal-main").css({
            "left": ((w - contw)/2) + "px",
            "top": ((h - conth)/2) + "px"
          });
        }
    });

    G_NOW_SHELf = shelfID;
    
    $("#shelf-selector").trigger("click");
}

function setBookInfo(bookID) {
    var shelf = G_SHELVES[G_NOW_SHELf];
    var book_info = shelf.books.filter(function(val, idx){
      if(val.book_id == bookID) return true;
    });
    $("#modal-book-img").attr("src", book_info[0].file_name);
    $("#modal-book-name").text(book_info[0].name);
    $("#modal-isbn").text(book_info[0].isbn);
    $("#modal-comment").text(book_info[0].comment);
    $("#modal-tags").text(book_info[0].tags);
}

$(document).ready( function(){
  $.getJSON("shelves.json", function(json){
    var bs_count=0;
    json[0].bookshelves.forEach(function(shelf){
      G_SHELVES.push(shelf);
      var shelf_id = "shelf" + shelf.shelf_id;
      //bookshelfが複数の可能性があるためループ処理

      $("#menu-shelves").loadTemplate(
        "sidebar-template.html",{
          "data_onclick": "changeShelf("+shelf.shelf_id+")",
          "shelf_name": '<span class="glyphicon glyphicon-book"></span> ' + shelf.shelf_name
        },
        {append:true, async: false}
      );

      console.log(shelf.books);
      /*
      //booksの表示のため別テンプレート呼び出し
      shelf.books.forEach(function(book){
        var book_id = "book" + book.book_id;
        $("#" + shelf_id + " .books").loadTemplate(
            "books.template.html",{
              "isbn" : book.isbn,
              "name" : book.name,
              "file_name" : book.file_name,
              "comment" : book.comment,
              "book_id" : book_id
            },
            {append:true, async: false}
        );
        //tagsの表示のため別テンプレート呼び出し
        book.tags.forEach(function(tag){
          $("#" + shelf_id + " .books #" + book_id).loadTemplate(
            "tags.template.html",{
              "tag" : tag
            },
            {append:true, async: false}
          );
        }); // tags
      });   // books
      */
    });     // bookshelves
  });       // getJSON
  console.log(G_SHELVES);
});