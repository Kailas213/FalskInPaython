const express = require('express');
const path = require('path');
const app = express();

app.set('view engine', 'ejs');                // Required
app.set('views', path.join(__dirname, 'views')); // Ensure path is correct

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.get('/', (req, res) => {
    res.render('index'); // must match views/index.ejs
});
const SubmitURL = 'http://localhost:8000/add_user';



app.post('/add_user', async (req, res) => {
    try {
        const response = await fetch(SubmitURL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(req.body)
        });
        const data = await response.json();
        res.render('index', { message: data.message });
    } catch (err) {
        console.error(err);
        res.render('index', { message: 'Error submitting data' });
    }
});


app.listen(3000, () => console.log('Server running on http://localhost:3000'));




// const express = require('express');
// const path = require('path');
// const fetch = require('node-fetch');

// const app = express();

// app.set('view engine', 'ejs');
// app.set('views', path.join(__dirname, 'views'));

// app.use(express.urlencoded({ extended: true }));
// app.use(express.json());

// const SubmitURL = 'http://localhost:8000/add_user';





// // Routes
// app.get('/', (req, res) => {
//     res.render('index'); // This will look for views/index.ejs
// });


// // app.post('/add_user', async (req, res) => {
// //     try {
// //         const response = await fetch(SubmitURL, {
// //             method: 'POST',
// //             headers: { 'Content-Type': 'application/json' },
// //             body: JSON.stringify(req.body)
// //         });
// //         const data = await response.json();
// //         res.render('index', { message: data.message });
// //     } catch (err) {
// //         console.error(err);
// //         res.render('index', { message: 'Error submitting data' });
// //     }
// // });

// app.listen(3000, () => {
//     console.log('Server running at http://localhost:3000/');
// });
