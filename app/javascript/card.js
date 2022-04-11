
const payjp = Payjp('pk_test_8105d1a2b79eea9068cdbb30')

const elements = payjp.elements()


// $(function () {
//   //URLにcardsが含まれている際に発火します。
//   if (document.URL.match(/card/)){
//
//     //公開鍵を記述
//     var payjp = Payjp("pk_test_8105d1a2b79eea9068cdbb30");
//     //Elements インスタンスを生成します。
//     var elements = payjp.elements();
//     var numberElement = elements.create('cardNumber');
//     var expiryElement = elements.create('cardExpiry');
//     var cvcElement = elements.create('cardCvc');
//
//     numberElement.mount('#number-form');
//     expiryElement.mount('#expiry-form');
//     cvcElement.mount('#cvc-form');
//
//     var submit_btn = $("#info_submit");
//     submit_btn.on('click', function (e) {
//       e.preventDefault();
//       payjp.createToken(numberElement).then(function (response) {
//
//         if (response.error) {  //  通信に失敗したとき
//           alert(response.error.message)
//           regist_card.prop('disabled', false)
//         } else {
//           $("#card_token").append(
//             `<input type="hidden" name="payjp_token" value=${response.id}>
//             <input type="hidden" name="card_token" value=${response.card.id}>`
//           );
//           $('#card_form')[0].submit();
//
//           $("#card_number").removeAttr("name");
//           $("#cvc-from").removeAttr("name");
//           $("#exp_month").removeAttr("name");
//           $("#exp_year").removeAttr("name");
//         };
//       });
//     });
//   }
// });


// const payjp = () => {
//   Payjp.setPublicKey(process.env.PAYJP_PUBLIC_KEY);
//   const form = document.getElementById("card_form");
//   form.addEventListener("submit", function(e) {
//     e.preventDefault();
//     const card = {
//       number: document.getElementById("number").value,
//       name: document.getElementById("name").value,
//       cvc: document.getElementById("cvc").value,
//       exp_month: document.getElementById("exp_month").value,
//       exp_year: `20${document.getElementById("exp_year").value}`,
//     };
//     Payjp.createToken(card, function(status, response) {
//       console.log(status)
//       if (status === 200) {
//         const token = response.id;
//         const tokenObj = `<input value=${token} name='token_id' type="hidden">`;
//         const cardForm = document.getElementById("card_form");
//         cardForm.insertAdjacentHTML("beforeend", tokenObj);
//         document.getElementById("number").removeAttribute("name");
//         document.getElementById("name").removeAttribute("name");
//         document.getElementById("cvc").removeAttribute("name");
//         document.getElementById("exp_month").removeAttribute("name");
//         document.getElementById("exp_year").removeAttribute("name");
//         document.getElementById("card_form").submit();
//       } else {
//         alert("カード情報が正しくありません")
//       }
//     });
//   });
// };
// window.addEventListener("load", payjp);
