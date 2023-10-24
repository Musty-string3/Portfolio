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
  // TODO ここにも配列で指定すれば再利用できる
  changeValidClass($("#post_post_name"), $("#post_post_name").data("max-length")); // フォームチェック
  changeValidClass($("#post_explanation"), $("#post_explanation").data("max-length")); // フォームチェック
}


// バリデーションチェック結果に応じてclassを変更する
function changeValidClass(elem, maxLength) {
  // パスワード6文字以上でOK
  if (maxLength == 999 && elem.val().length < 6) {
    elem.removeClass("is-valid");
    elem.addClass("is-invalid");
  }else if (maxLength == 999) {
    elem.removeClass("is-invalid");
    elem.addClass("is-valid");
  }else if (elem.val() === "" || elem.val().length > maxLength) {
    elem.removeClass("is-valid");
    elem.addClass("is-invalid");
  } else {
    elem.removeClass("is-invalid");
    elem.addClass("is-valid");
  }
}


jQuery(document).on('turbolinks:load', function(){
  $(document).ready(function() {


    // 文字数カウントしたい
    const array = [
      ["#user_name", "#new_user_name_countUp", 20], //ユーザー新規登録のニックネーム
      ["#user_name", "#user_name_countUp", 20], //ユーザー編集のニックネーム
      ["#post_post_name", "#name_countUp", 20], //投稿名(新規、編集)
      ["#post_explanation", "#explanation_countUp", 100], //投稿の説明(新規、編集)
      ["#room_group_name", "#group_name_countUp", 20],  //グループチャット名(新規、編集)
      ["#room_group_group_description", "#group_description_countUp", 100], //グループチャットの説明(新規、編集)
      ["#user_password", "#new_user_password_countUp", 6],  //ユーザー新規登録のパスワード
      ["#user_password_confirmation", "#new_user_password_check_countUp", 6], //ユーザー新規登録のパスワード確認
      ["#user_introduction", "#user_introduction_countUp", 100] //ユーザーの説明(編集)
    ]
    for (const value of array) {
      setupTextCounter(value[0], value[1], value[2]);
    }

    // 文字数カウント
    function setupTextCounter(inputId, countUpId, maxLength){
      console.log('hello');
      const textInput = $(inputId);
      const countUp = $(countUpId);
      textInput.on('keyup', function(){
        const textLength = textInput.val().length;
        countUp.text(textLength);
        // パスワード6文字以上でOK
        if (maxLength == 6 && textLength < 6) {
          countUp.css('color', 'red');
        }else if (maxLength == 6) {
          countUp.css('color', 'black');
        }else if (textLength > maxLength) {
          countUp.css('color', 'red');
        }else{
          countUp.css('color', 'black');
        }
      });
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