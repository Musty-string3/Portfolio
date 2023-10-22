// 投稿画像入力時に画面に画像を表示する
function loadImage(obj){
  let fileReader;
  $('#preview').empty();
  $("#error_message_post_image").empty();
  $('#images_check_field').hide();
  if (obj.files.length > 6) {
    $("#error_message_post_image").html("画像は6枚以下で指定してください");
    return false;
  }
	for (let i = 0; i < obj.files.length; i++) {
		fileReader = new FileReader();
		fileReader.onload = (function (e) {
			$('#preview').append('<img class="m-1 preview_img border border-secondary rounded" src="' + e.target.result + '">');
			$('#images_check_field').show();
		});
		fileReader.readAsDataURL(obj.files[i]);
	}
}

// GoogleMapの初期設定(清水寺)
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

// ユーザーが操作して動かすGoogleMap
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

  // ファイルの選択バリデーション
  const postImages = $("#post_images")
  const postImagesError = $(".post_images_error")
  if (postImages.prop('files').length > 6 || postImages.prop('files').length === 0) {
    postImagesError.removeClass('d-none');
    postImagesError.addClass('d-block');
  } else {
    postImagesError.removeClass('d-block');
    postImagesError.addClass('d-none');
  }

  // テキストバリエーションエラー
  changeValidClass($("#post_post_name"), $("#post_post_name").data("max-length")); // フォームチェック
  changeValidClass($("#post_explanation"), $("#post_explanation").data("max-length")); // フォームチェック
}


// バリデーションチェック結果に応じてclassを変更する
function changeValidClass(elem, maxLength) {
  if (elem.val() === "" || elem.val().length > maxLength) {
    elem.removeClass("is-valid");
    elem.addClass("is-invalid");
  } else {
    elem.removeClass("is-invalid");
    elem.addClass("is-valid");
  }
}


jQuery(document).on('turbolinks:load', function(){
  $(document).ready(function() {

    // 文字数カウント
    function setupTextCounter(inputId, countUpId, maxLength){
      console.log('hello');
      const textInput = $(inputId);
      const countUp = $(countUpId);
      textInput.on('keyup', function(){
        const textLength = textInput.val().length;
        countUp.text(textLength);
        if (textLength > maxLength) {
          countUp.css('color', 'red');
        }else{
          countUp.css('color', 'black');
        }
      });
    }

    // 文字数カウントしたいフォームのID指定
    const array = [
      ["#post_post_name", "#name_countUp", 20],
      ["#post_explanation", "#explanation_countUp", 100]
    ]
    for (const value of array) {
      setupTextCounter(value[0], value[1], value[2]);
    }

    // タグ
    $('#post_tag').on('input', function() {
      const tagText = $(this).val().trim();
      const tags = tagText.split('　');
      const check_post_tags = $("#check_post_tags")
      check_post_tags.empty();

      // 各タグに # を付けて表示
      tags.forEach(tag => {
        if (tag.trim() !== '') {
          const tagElement = $('<span></span>').text('#' + tag.trim() + ' ');
          check_post_tags.append(tagElement);
        }
      });
    });

    // 投稿画像を指定しないとGoogleMapのボタンを押せない
    const fileInput = $('#post_images');
    fileInput.on('change', function(){
      if (fileInput[0].files.length > 0) {
        $('#GoogleMap').removeClass('btn btn-lg btn-primary').addClass('btn btn-primary');
        $("#GoogleMap").prop("disabled", false);
      }else{
        $('#GoogleMap').removeClass('btn btn-primary').addClass('btn btn-lg btn-primary');
        $("#GoogleMap").prop("disabled", true);
      }
    });

    // バリデーションチェックする入力欄のclass制御
    $(".valid-check").on("blur input", function () {
      const max_length = $(this).data("max-length");
      changeValidClass($(this), max_length);
    });

    // Enterキーを押せなくする
    // $(document).on("keypress", function(event) {
    //   if (event.keyCode === 13) {
    //     return false;
    //   }
    // });
  });
});

// ref: https://stackoverflow.com/questions/33178843/es6-export-default-with-multiple-functions-referring-to-each-other
export default {loadImage, initMap, codeAddress, validateForm};