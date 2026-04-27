const express = require('express');
const { exec } = require('child_process');

const app = express();
app.use(express.json());
app.use(express.static('public'));

app.post('/diagnose', (req, res) => {
    const symptoms = req.body.symptoms;

    if (!symptoms || symptoms.length === 0) {
        return res.json({ disease: "No symptoms selected" });
    }

    let facts = symptoms
        .map(s => `assertz(symptom(${s}))`)
        .join(',');

    // ✅ FIX: safer command (single quotes for Linux)
    let command = `swipl -q -s prolog/medical.pl -g 'clear,${facts},diagnose(D),write(D),halt.'`;

    console.log("Running:", command);

    exec(command, (error, stdout, stderr) => {
        console.log("STDOUT:", stdout);
        console.log("STDERR:", stderr);

        if (error) {
            return res.json({
                disease: "Error running Prolog",
                debug: stderr
            });
        }

        const result = stdout.trim();

        res.json({ disease: result || "unknown" });
    });
});

app.get('/test-prolog', (req, res) => {
    exec("swipl --version", (err, stdout, stderr) => {
        if (err) return res.send(stderr);
        res.send(stdout);
    });
});

// ✅ IMPORTANT for Render
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});