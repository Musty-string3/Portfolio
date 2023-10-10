// ref: https://blog.ver001.com/javascript-image-preview-multiple/

// 投稿画像入力時に画面に画像を表示する
function loadImage(obj){
  let fileReader;
  $('#preview').empty();  // previewの中身を全消去(empty)する
  $("#error_message_post_image").empty();
  if (obj.files.length > 6) {
    $("#error_message_post_image").html("画像は6枚以下で指定してください");
    return false;  //breakのようなもの
  }
	for (let i = 0; i < obj.files.length; i++) {
		fileReader = new FileReader();
		fileReader.onload = (function (e) {
		  // idがpreviewを探し、その箇所に要素を追加(append)していく
			$('#preview').append('<img class="m-1 preview_img" src="' + e.target.result + '">');
		});
		fileReader.readAsDataURL(obj.files[i]);
	}
}

let map
function initMap(){
  geocoder = new google.maps.Geocoder()

  map = new google.maps.Map(document.getElementById('map'), {
    center:  {lat: 34.9948561, lng:135.7850463},
    zoom: 15,
  });

  marker = new google.maps.Marker({
    position:  {lat: 34.9948561, lng:135.7850463},
    map: map
  });

}

let geocoder
let aft
let marker
function codeAddress(){
  geocoder = new google.maps.Geocoder()
  let inputAddress = document.getElementById('address').value;
  geocoder.geocode( { 'address': inputAddress}, function(results, status) {
    if (status == 'OK') {
      //マーカーが複数できないようにする
      if (aft == true){
          marker.setMap(null);
      }

      //新しくマーカーを作成する
      map.setCenter(results[0].geometry.location);
          marker = new google.maps.Marker({
          map: map,
          position: results[0].geometry.location,
          draggable: true	// ドラッグ可能にする
      });

      //二度目以降か判断
      aft = true

      //検索した時に緯度経度を入力する
      document.getElementById('lat').value = results[0].geometry.location.lat();
      document.getElementById('lng').value = results[0].geometry.location.lng();

      // マーカーのドロップ（ドラッグ終了）時のイベント
      google.maps.event.addListener( marker, 'dragend', function(ev){
        // イベントの引数evの、プロパティ.latLngが緯度経度
        document.getElementById('lat').value = ev.latLng.lat();
        document.getElementById('lng').value = ev.latLng.lng();
      });
    } else {
      alert('該当する結果がありませんでした。');
    }
  });
}

// バリエーションエラー表示
function validateForm() {
  // バリデーションエラーフラグ初期値
  let validateErrorFlg = false;

  // ファイルの選択バリデーション
  const postImages = $("#post_images")
  const postImagesError = $(".post_images_error")
  if (postImages.prop('files').length > 6 || postImages.prop('files').length === 0) {
    validateErrorFlg = true;
    postImagesError.removeClass('d-none');
    postImagesError.addClass('d-block');
  } else {
    postImagesError.removeClass('d-block');
    postImagesError.addClass('d-none');
  }

  changeValidClass($("#post_post_name")); // フォームチェック
  changeValidClass($("#post_explanation")); // フォームチェック

  // 対象のフォームにis-invalidが付与されていれば、
  // バリデーションエラーありと判定する
  $(".valid-check").each( function() {
    if ($(this).hasClass("is-invalid")) {
      validateErrorFlg = true; // フラグ上書き
    }
  });

  if (validateErrorFlg) {
    // submitボタンを再度有効化
    $.ajax({}).done(function() { $("#submit-btn").prop("disabled", false); })
    return false; // 送信処理中断
  }
}


// バリデーションチェック結果に応じてclassを変更する
// TODO toggleClass()使えないか？
function changeValidClass(elem) {
  if (elem.val() === "") {
    elem.removeClass("is-valid");
    elem.addClass("is-invalid");
  } else {
    elem.removeClass("is-invalid");
    elem.addClass("is-valid");
  }
}


jQuery(document).on('turbolinks:load', function(){
  $(document).ready(function() {

    // 入力時に値を取得し、フォーカスが外れたら画面に文字を表示する
    // 投稿名
    const text_name = $("#post_post_name");
    text_name.on("input", function() {
      $(this).blur(function(){
        $("#check_post_name").text(text_name.val());
      });
    });
    if (text_name !== ""){
      $("#check_post_name").text(text_name.val());
    }

    // 投稿の説明
    const text_explanation = $('#post_explanation');
    text_explanation.on('input', function(){
      $(this).blur(function(){
        $("#check_post_explanation").text(text_explanation.val());
      });
    });
    if (text_explanation !== ""){
      $("#check_post_explanation").text(text_explanation.val());
    }

    // タグ
    $('#post_tag').on('input', function() {
      // タグの入力値を取得
      const tagText = $(this).val().trim();

      // カンマで区切られたタグを分割
      const tags = tagText.split('　');

      // タグを表示する前にコンテナをクリア
      $('#check_post_tags').empty();

      // 各タグに # を付けて表示
      tags.forEach(tag => {
        if (tag.trim() !== '') {
          const tagElement = $('<span></span>').text('#' + tag.trim() + ' ');
          $('#check_post_tags').append(tagElement);
        }
      });
    });

    // バリデーションチェックする入力欄のclass制御
    $(".valid-check").on("blur input", function () {
      changeValidClass($(this));
    })

  });
});

// ref: https://stackoverflow.com/questions/33178843/es6-export-default-with-multiple-functions-referring-to-each-other
export default {loadImage, initMap, codeAddress, validateForm};