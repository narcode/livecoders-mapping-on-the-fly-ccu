import './main.css';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';

let app = Elm.Main.init({
  node: document.getElementById('root')
  , flags: { endpoint: process.env.ELM_APP_DEV_URL }
});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();

// ports:
app.ports.sendNum.subscribe(function(num) {
  setTimeout(function() {
    let t = document.getElementById(num);
    let rows = t.scrollHeight / 22;
    if (rows > 16) {
      t.rows = 15;
    } else {
      t.rows = rows;
    }
  },150);
});