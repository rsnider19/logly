#!/usr/bin/env node
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import OpenAI from "openai";
import Papa from "papaparse";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const inputFile = path.join(__dirname, "Supabase SQL Query.csv");
const outputFile = path.join(__dirname, "activity_enriched_keywords.csv");

const client = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

if (!fs.existsSync(inputFile)) {
  console.error(`❌ CSV file not found: ${inputFile}`);
  process.exit(1);
}

const csvText = fs.readFileSync(inputFile, "utf8");
const { data } = Papa.parse(csvText, { header: true, skipEmptyLines: true });

async function enrichActivity(name, exclude) {
  const excludeText = exclude ? `Exclude: ${exclude}.` : "";
  const prompt = `Generate 10 domain-specific general-context keywords for the activity "${name}". ${excludeText} Exclude the activity name itself and brand names. Output only a comma-separated list.`;

  const response = await client.chat.completions.create({
    model: "gpt-4o-mini",
    messages: [{ role: "user", content: prompt }],
    temperature: 0.8,
  });

  return response.choices[0].message.content.trim();
}

async function main() {
  console.log(`📄 Loaded ${data.length} activities`);
  const results = [];

  for (let i = 0; i < data.length; i++) {
    const { activity_id, name, string_agg } = data[i];
    console.log(`🔍 Enriching: ${name} (${i + 1}/${data.length})`);

    try {
      const keywords = await enrichActivity(name, string_agg);
      results.push({ activity_id, enriched_keywords: keywords });
    } catch (err) {
      console.error(`⚠️ Error for "${name}": ${err.message}`);
      results.push({ activity_id, enriched_keywords: "" });
    }

    // polite delay to avoid rate limits
    await new Promise((r) => setTimeout(r, 1200));
  }

  const csv = Papa.unparse(results);
  fs.writeFileSync(outputFile, csv);
  console.log(`✅ Done! Saved to ${outputFile}`);
}

main();
