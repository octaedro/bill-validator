# Bill Validator

Bill Validator is a Flutter application that uses OpenAI's vision capabilities to analyze receipts and bills. It extracts merchant information, line items, and totals from photos of receipts, then verifies if the sum of line items matches the total amount.

## Features

- 📷 Take photos of receipts/bills or select from gallery
- 🔍 Extract business name, line items, and total amount
- ✅ Verify if line items sum up to the total
- 📊 View detailed breakdown of each receipt
- 📝 Manage a list of processed receipts

## Screenshots

(Screenshots will be added here)

## Setup

### Prerequisites

- Flutter SDK (>=3.1.3)
- Dart SDK (>=3.1.3)
- An OpenAI API key with access to the `gpt-4o` model

### Installation

1. Clone the repository:

   ```
   git clone https://github.com/your-username/bill-validator.git
   cd bill-validator
   ```

2. Create a `.env` file in the root directory with your OpenAI API key:

   ```
   OPENAI_API_KEY=your_openai_api_key_here
   ```

3. Install dependencies:

   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

Or manually:

```
cd ios
pod install
cd ..
flutter run -d ios
```

## How It Works

1. The app captures an image of a receipt using the device camera or selects one from the gallery
2. The image is sent to OpenAI's API for analysis
3. OpenAI extracts the business name, line items, and total amount
4. The app verifies if the sum of line items equals the total amount
5. Results are displayed in a detailed view and saved to the list

## Technologies Used

- Flutter for cross-platform mobile development
- OpenAI's gpt-4o model for image analysis
- Flutter_dotenv for environment variable management

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
