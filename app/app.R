library(shiny)

ui <- fluidPage(
  titlePanel("TRI Air vs Water Releases Explorer"),
  
  h4("App Overview"),
  p("This app explores toxic chemical releases from the EPA Toxic Release Inventory (TRI) dataset. Users can select a state and compare air and water release amounts through interactive visualizations."),
  p("The app examines the distribution of releases and evaluates whether there are significant differences between air and water pathways using a Wilcoxon rank-sum test. It helps identify patterns across states."),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "state",
        "Choose a state:",
        choices = NULL
      ),
      
      checkboxGroupInput(
        "pathways",
        "Choose release pathway(s):",
        choices = c("Air Releases" = "air_releases",
                    "Water Releases" = "water"),
        selected = c("air_releases", "water")
      ),
      
      sliderInput(
        "bins",
        "Number of bins (for histogram only):",
        min = 5,
        max = 50,
        value = 30
      ),
      
      helpText("When both pathways are selected, the app displays a boxplot comparison. When one pathway is selected, the app displays a histogram.")
    ),
    
    mainPanel(
      plotOutput("distPlot"),
      br(),
      h4("Statistical Test Result"),
      verbatimTextOutput("testResult"),
      hr(),
      h4("Project Information"),
      
      p(strong("Author: "), "Kira Lu"),
      
      p(strong("Research Question: "),
        "How do air and water toxic release amounts differ across selected U.S. states in the EPA TRI dataset?"),
      
      p(strong("Data Source: "),
        "EPA Toxic Release Inventory (TRI) dataset."),
      
      p(strong("Methods: "),
        "Users select a state and release pathway. The app visualizes release distributions using histograms or boxplots and compares air and water releases using a Wilcoxon rank-sum test."),
      
      p(strong("AI Disclosure: "),
        "AI tools were used to support code debugging, wording, and formatting. The final app design and data interpretation were reviewed and completed by the author."),
      
      p(strong("GitHub Repository: ")),
      a("https://github.com/puffconw/r-project-test",
        href = "https://github.com/puffconw/r-project-test",
        target = "_blank")
    )
  )
)

server <- function(input, output, session) {
  
  tri <- read.csv("tri_small.csv")
  
  updateSelectInput(
    session,
    "state",
    choices = sort(unique(tri$state)),
    selected = sort(unique(tri$state))[1]
  )
  
  state_data <- reactive({
    req(input$state)
    tri[tri$state == input$state, ]
  })
  
  output$distPlot <- renderPlot({
    req(input$pathways)
    
    dat <- state_data()
    
    if (length(input$pathways) == 0) {
      plot.new()
      text(0.5, 0.5, "Please select at least one release pathway.")
      return()
    }
    
    if (length(input$pathways) == 1) {
      x <- dat[[input$pathways[1]]]
      x <- x[!is.na(x)]
      
      if (length(x) < 2) {
        plot.new()
        text(0.5, 0.5, "Not enough data for this selection.")
        return()
      }
      
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      hist(
        x,
        breaks = bins,
        col = "#2C7BB6",
        border = "white",
        main = paste("Distribution of", 
                     ifelse(input$pathways[1] == "air_releases", "Air Releases", "Water Releases"),
                     "in", input$state),
        xlab = "Release Amount (lbs)"
      )
      
    } else {
      air <- dat$air_releases
      water <- dat$water
      
      air <- air[!is.na(air)]
      water <- water[!is.na(water)]
      
      if (length(air) < 2 || length(water) < 2) {
        plot.new()
        text(0.5, 0.5, "Not enough data for comparing air and water releases.")
        return()
      }
      
      boxplot(
        air,
        water,
        names = c("Air Releases", "Water Releases"),
        col = c("#2C7BB6", "#D7191C"),
        border = "gray30",
        main = paste("Air vs Water Releases in", input$state),
        ylab = "Release Amount (lbs)"
      )
    }
  })
  
  output$testResult <- renderText({
    req(input$pathways)
    
    dat <- state_data()
    
    if (!all(c("air_releases", "water") %in% input$pathways)) {
      return("Select both Air Releases and Water Releases to run the Wilcoxon rank-sum test.")
    }
    
    air <- dat$air_releases
    water <- dat$water
    
    air <- air[!is.na(air)]
    water <- water[!is.na(water)]
    
    if (length(air) < 2 || length(water) < 2) {
      return("Not enough data in this state to run the test.")
    }
    
    test <- wilcox.test(air, water, exact = FALSE)
    
    paste0(
      "State: ", input$state, "\n",
      "Test: Wilcoxon rank-sum test\n\n",
      "Air sample size: ", length(air), "\n",
      "Water sample size: ", length(water), "\n",
      "W statistic: ", round(test$statistic, 3), "\n",
      "p-value: ", signif(test$p.value, 4), "\n\n",
      "Interpretation: ",
      if (test$p.value < 0.05) {
        "The distributions of air releases and water releases are significantly different in this state."
      } else {
        "There is no statistically significant difference between the distributions of air releases and water releases in this state."
      }
    )
  })
}

shinyApp(ui = ui, server = server)