const payjp = () => {
  Payjp.setPublicKey(process.env.PAYJP_PUBLIC_KEY);
  const form = document.getElementById("card_form");
  form.addEventListener("submit", function(e) {
    e.preventDefault();
    const card = {
      number: document.getElementById("number").value,
      name: document.getElementById("name").value,
      cvc: document.getElementById("cvc").value,
      exp_month: document.getElementById("exp_month").value,
      exp_year: `20${document.getElementById("exp_year").value}`,
    };
    Payjp.createToken(card, function(status, response) {
      console.log(status)
      if (status === 200) {
        const token = response.id;
        const tokenObj = `<input value=${token} name='token_id' type="hidden">`;
        const cardForm = document.getElementById("card_form");
        cardForm.insertAdjacentHTML("beforeend", tokenObj);
        document.getElementById("number").removeAttribute("name");
        document.getElementById("name").removeAttribute("name");
        document.getElementById("cvc").removeAttribute("name");
        document.getElementById("exp_month").removeAttribute("name");
        document.getElementById("exp_year").removeAttribute("name");
        document.getElementById("card_form").submit();
      } else {
        alert("カード情報が正しくありません")
      }
    });
  });
};
window.addEventListener("load", payjp);
