# Testing Guide - My Belief System MVP

## 🚀 Quick Start

### 1. Install Dependencies & Run Migrations

```bash
# Install gems (including annotate)
bundle install

# Run database migrations
bundle exec rails db:migrate

# Annotate models with schema information
bundle exec annotate --models

# Seed the database with sample data
bundle exec rails db:seed
```

### 2. Start the Server

```bash
bin/rails server
```

Visit: **http://localhost:3000**

---

## 🧪 Complete Testing Flow

### **Step 1: Welcome Page** (`/`)
- ✅ See hero section: "Understand your political values"
- ✅ See 4 benefits (15-20 min, no wrong answers, refine anytime, privacy)
- ✅ See 3 preview cards (Value Portrait, Alignment Scores, Track Changes)
- ✅ Click "Get Started" button

### **Step 2: Profile Questions** (`/onboarding`) - **NEW!**
- ✅ Select country from dropdown (required)
  - Options: United States, France, United Kingdom, Germany, Canada
- ✅ Enter age (optional)
- ✅ Select gender (optional)
- ✅ Select political engagement level (optional)
- ✅ See privacy notice
- ✅ Click "Continue to Questions"

### **Step 3: Onboarding Questions** (`/onboarding/question/1`)
- ✅ See progress bar (Question 1 of 24, 4%)
- ✅ Answer multiple choice questions (click to auto-advance)
- ✅ Answer slider questions (drag slider, click "Next")
- ✅ Use "Back" button to change previous answers
- ✅ Use "Skip" button to skip questions
- ✅ Navigate through all 24 questions

### **Step 4: Value Portrait** (`/onboarding/portrait`)
- ✅ See "Your Value Portrait" header
- ✅ See radar chart with 8 dimensions
- ✅ See detailed breakdown of each dimension:
  - Position indicator (left/right/center)
  - Strength (Strong/Moderate/Weak)
  - Confidence (High/Medium/Low)
  - Lean direction
- ✅ Click "View My Dashboard"

### **Step 5: Alignment Dashboard** (`/dashboard`) - **UPDATED!**
- ✅ See "Your Alignment Dashboard" header
- ✅ See alignment legend (color coding)
- ✅ See 7 actor cards with:
  - **Actor image/avatar** (NEW!)
  - Name, type, role
  - Alignment score (0-100%)
  - Color-coded progress bar
  - Trend indicator (↗↘→)
  - Strong alignment dimensions
  - Weak alignment dimensions
- ✅ Click "View Details" on any actor

### **Step 6: Actor Detail - Personality** (`/actors/3` - Joe Biden) - **UPDATED!**
- ✅ See actor header with:
  - **Portrait image** (NEW!)
  - Name, role, party
  - Description
  - Overall alignment score
- ✅ See comparison radar chart (user vs actor)
- ✅ See dimension-by-dimension breakdown
- ✅ **See "Recent Interventions" section** (NEW!)
  - Platform icons (𝕏 for Twitter, ▶️ for YouTube, 📰 for press releases)
  - Intervention type (tweet, speech, video)
  - Content preview
  - Time ago (e.g., "2 days ago")
  - "View source" link

**Test with these personalities:**
- Joe Biden (3 interventions)
- Donald Trump (4 interventions)
- Kamala Harris (3 interventions)
- Bernie Sanders (4 interventions)
- Ron DeSantis (4 interventions)

### **Step 7: Actor Detail - Party** (`/actors/1` - Democratic Party) - **UPDATED!**
- ✅ See party header with:
  - **Party logo** (NEW!)
  - Name, type, location
  - Description
  - **"View Official Program" link** (NEW!)
  - Overall alignment score
- ✅ Click "View Official Program" to visit party platform
- ✅ See comparison radar chart
- ✅ See dimension-by-dimension breakdown
- ✅ No interventions section (parties don't have interventions)

### **Step 8: My Values Page** (`/my-values`)
- ✅ See "My Value Portrait" header
- ✅ See creation date
- ✅ See radar chart
- ✅ See detailed breakdown with:
  - Position slider
  - Intensity/Confidence stats
  - Explanation for each dimension
- ✅ Click "See How Politicians Align" to return to dashboard

---

## 📊 Seeded Data

### **Actors (7 total)**

**Parties (2):**
- Democratic Party (with program URL)
- Republican Party (with program URL)

**Personalities (5):**
- Joe Biden (President, Democratic)
- Donald Trump (Former President, Republican)
- Kamala Harris (Vice President, Democratic)
- Bernie Sanders (Senator, Independent)
- Ron DeSantis (Governor, Republican)

### **Interventions (18 total)**
- Joe Biden: 5 interventions (tweets, speeches, videos)
- Donald Trump: 4 interventions
- Kamala Harris: 3 interventions
- Bernie Sanders: 4 interventions
- Ron DeSantis: 4 interventions

### **Questions (31 total)**
- **24 universal questions** (apply to all countries)
  - 3 questions per dimension (8 dimensions)
- **7 US-specific questions**:
  - Medicare for All
  - Second Amendment / Gun Rights
  - Immigration / Undocumented Immigrants
  - Abortion (post-Roe v. Wade)
  - Electoral College
  - Police Reform
  - Student Debt Cancellation

---

## 🎯 What to Test

### **Country-Specific Onboarding**
1. Select "United States" → Should see US-specific questions mixed with universal
2. Select "France" → Should only see universal questions (no France-specific yet)

### **Actor Images**
1. All actors should display images on dashboard
2. Images should be circular avatars
3. Fallback to initials if image fails to load

### **Interventions Feed**
1. Only personalities should show interventions
2. Parties should NOT show interventions section
3. Each intervention should show platform icon
4. "View source" links should work

### **Program Links**
1. Parties should show "View Official Program" link
2. Link should open in new tab
3. Personalities should NOT show program link

---

## 🐛 Known Limitations (Mock Data)

- Alignment scores are randomly generated
- User portrait is mock data (not based on actual answers)
- Interventions are sample data (not real-time)
- Only US-specific questions exist (other countries need to be added)
- No authentication (anyone can access all pages)

---

## 📝 Next Steps

1. ✅ Run migrations
2. ✅ Seed database
3. ✅ Test complete user flow
4. 🔲 Add more country-specific questions (France, UK, Germany, Canada)
5. 🔲 Implement real alignment calculation
6. 🔲 Add authentication (Devise)
7. 🔲 Write RSpec tests
8. 🔲 Connect real data sources for interventions

---

## 🆘 Troubleshooting

### Database Issues
```bash
# Reset database completely
bundle exec rails db:drop db:create db:migrate db:seed
```

### Missing Images
- Images are loaded from Wikipedia
- If images don't load, check internet connection
- Fallback avatars will show initials

### Seed Errors
```bash
# Check if migrations ran
bundle exec rails db:migrate:status

# Re-run seeds
bundle exec rails db:seed
```

---

**Happy Testing! 🚀**

