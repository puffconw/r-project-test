# VTPEH 6270 - Differences in Toxic Chemical Release Pathways:   
## A Comparison of Air and Water Releases  

## 👤 Author  
Kira Lu  
Cornell University, Master of Public Health (MPH)  

### Contact  
Email: ql377@cornell.edu  

---

## 📌 Project Overview  
This repository contains materials for the VTPEH 6270 TRI 2024 analysis project.  

The project uses the U.S. Environmental Protection Agency (EPA) Toxics Release Inventory (TRI) 2024 dataset to examine patterns in toxic chemical releases across facilities, with a focus on comparing **air versus water release pathways**.  

The project includes exploratory analysis, simulation work, a final statistical report, and an interactive Shiny application.

---

## 🎯 Research Question  
Is the magnitude of toxic chemical releases associated with release pathway (air vs. water) among U.S. facilities in 2024?

---

## 🌐 Shiny App  
https://kira-lu.shinyapps.io/tri_app/

The Shiny application allows users to explore:
- State-level filtering  
- Air vs. water release comparisons  
- Interactive visualizations  
- Statistical test results  

---

## 📊 Data Source  
U.S. Environmental Protection Agency (EPA). Toxics Release Inventory (TRI) Basic Data File, 2024.  
Source: https://www.epa.gov/toxics-release-inventory-tri-program/tri-basic-data-files-calendar-years-1987-present 

---

## 🧪 Methods Overview  
- Records with non-missing air and water release values were included  
- Key variables:
  - `air_releases`: sum of fugitive and stack air emissions  
  - `water`: total water releases  
- Data were reshaped into long format  
- Log transformation (`log(1 + releases)`) was applied  
- A Wilcoxon rank-sum test was used to compare release distributions  

---
## 📁 Repository Structure  
- `data/raw/`: original TRI 2024 data file
- `data/processed/`: processed data files generated during analysis
- `scripts/exploration.R`: exploratory analysis script based on Check Point 03
- `scripts/simulation.R`: simulation script based on Check Point 04
- `output/figures/`: figures generated from analysis scripts
- `output/reports/`: PDF reports from previous check points
- 
## 📄 Deliverables  

### Final Deliverables
- Final report: [Final_report.pdf](output/reports/Final_report.pdf)
- Final report code: [analysis.R](scripts/analysis.R)
- Shiny application: [https://kira-lu.shinyapps.io/tri_app/](https://kira-lu.shinyapps.io/tri_app/)
- Shiny app code: [app.R](app/app.R)

### Previous Checkpoint Reports
- Check Point 02 report: [VTPEH6270_CP02.pdf](output/reports/VTPEH6270_CP02.pdf)
- Check Point 03 report: [VTPEH6270_CP03.pdf](output/reports/VTPEH6270_CP03.pdf)
- Check Point 04 report: [VTPEH6270_CP04.pdf](output/reports/VTPEH6270_CP04.pdf)

## Notes for Reproducibility
The analysis can be reproduced using the provided R scripts and dataset subset.  
All steps, including data processing, visualization, and statistical testing, are included in the repository.

Due to GitHub file size limitations, a subset of the TRI dataset is included in this repository (`tri_small.csv`). 
As a result, the outputs generated from the scripts in this repository (e.g., figures and summary statistics) may differ slightly from those presented in the original reports, which were based on the full dataset.
However, the overall analytical workflow and methodology remain consistent and reproducible.

## AI Tool Disclosure
This repository was developed with assistance from ChatGPT for help with repository organization, code formatting, and documentation. All analytical decisions, interpretations, and conclusions were made by the author.

## References

1. U.S. Environmental Protection Agency. Toxics Release Inventory (TRI) Program. Accessed March 18, 2026. https://www.epa.gov/toxics-release-inventory-tri-program

2. Agarwal N, Banternghansa C, Bui LTM. Toxic exposure in America: estimating fetal and infant health outcomes from 14 years of TRI reporting. J Health Econ. 2010;29(4):557-574. https://economics.mit.edu/sites/default/files/publications/JHE2010.pdf :contentReference[oaicite:0]{index=0}

3. Wilson SM, Fraser-Rahim H, Williams E, et al. Assessment of the distribution of toxic release inventory facilities in metropolitan Charleston: an environmental justice case study. Am J Public Health. 2012;102(10):1974-1980. https://doi.org/10.2105/AJPH.2012.300700 :contentReference[oaicite:1]{index=1}
