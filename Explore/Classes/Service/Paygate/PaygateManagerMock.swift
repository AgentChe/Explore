//
//  PaygateManagerMock.swift
//  Explore
//
//  Created by Andrey Chernyshev on 27.08.2020.
//  Copyright © 2020 Andrey Chernyshev. All rights reserved.
//

import RxSwift

final class PaygateManagerMock: PaygateManager {}

// MARK: Retrieve

extension PaygateManagerMock {
    func retrievePaygate() -> Single<PaygateMapper.PaygateResponse?> {
        .deferred { .just(self.createResponse()) }
    }
}

// MARK: Prepare prices

extension PaygateManagerMock {
    func prepareProductsPrices(for paygate: PaygateMapper.PaygateResponse) -> Single<PaygateMapper.PaygateResponse?> {
        .deferred { .just(self.createResponse()) }
    }
}

// MARK: Private

private extension PaygateManagerMock {
    func createResponse() -> PaygateMapper.PaygateResponse {
        (json: [:], paygate: createPaygate(), productsIds: [])
    }
    
    func createPaygate() -> Paygate {
        Paygate(main: createMainOffer(), specialOffer: createSpecialOffer())
    }
    
    func createMainOffer() -> PaygateMainOffer {
        PaygateMainOffer(options: [createOption1(), createOption2()])
    }
    
    func createOption1() -> PaygateOption {
        let caption = NSMutableAttributedString(string: "$1.90/week",
                                                     attributes: TextAttributes()
                                                        .font(Font.Poppins.semibold(size: 15.scale))
                                                        .lineHeight(25.scale)
                                                        .letterSpacing(0.06)
                                                        .dictionary)
        let captionPriceDivLocalizedRange = NSString(string: "$1.90/week").range(of: "$1.90")
        caption.addAttributes(TextAttributes()
                                        .font(Font.Poppins.bold(size: 20.scale))
                                        .letterSpacing(0.06).dictionary,
                              range: captionPriceDivLocalizedRange)
        
        let bottomLineAttrs = NSMutableAttributedString(string: "$89.99/paid once",
                                                        attributes: TextAttributes()
                                                            .font(Font.Poppins.semibold(size: 15.scale))
                                                            .lineHeight(25.scale)
                                                            .dictionary)
        let bottomLinePriceLocalizedRange = NSString(string: "$89.99/paid").range(of: "$89.99")
        bottomLineAttrs.addAttributes(TextAttributes()
                                        .font(Font.Poppins.bold(size: 20.scale))
                                        .letterSpacing(-0.08).dictionary,
                                      range: bottomLinePriceLocalizedRange)
        
        return PaygateOption(productId: "com.stars.lifetime9999",
                      title: "Lifetime".attributed(with: TextAttributes()
                        .font(Font.Poppins.bold(size: 20.scale))
                        .lineHeight(25.scale)
                        .letterSpacing(0.06)
                        .textColor(UIColor(red: 17 / 255, green: 17 / 255, blue: 17 / 255, alpha: 1))),
                      caption: caption,
                      subCaption: "in terms of 1 year".attributed(with: TextAttributes()
                        .font(Font.Poppins.semibold(size: 10.scale))
                        .letterSpacing(0.06)
                        .lineHeight(13.scale)
                        .textColor(UIColor(red: 17 / 255, green: 17 / 255, blue: 17 / 255, alpha: 1))),
                      save: "SAVE 75%".attributed(with: TextAttributes()
                        .font(Font.Poppins.semibold(size: 13.scale))
                        .letterSpacing(-0.08)
                        .textColor(UIColor.white)
                        .lineHeight(18.scale)),
                      bottomLine: bottomLineAttrs)
    }
    
    func createOption2() -> PaygateOption {
        let caption = NSMutableAttributedString(string: "$69.99/year",
                                                     attributes: TextAttributes()
                                                        .font(Font.Poppins.semibold(size: 15.scale))
                                                        .lineHeight(25.scale)
                                                        .letterSpacing(0.06)
                                                        .dictionary)
        let captionPriceDivLocalizedRange = NSString(string: "$69.99/year").range(of: "$69.99")
        caption.addAttributes(TextAttributes()
                                        .font(Font.Poppins.bold(size: 20.scale))
                                        .letterSpacing(0.06).dictionary,
                              range: captionPriceDivLocalizedRange)
        
        return PaygateOption(productId: "com.stars.weekly899",
                      title: "3 days FREE".attributed(with: TextAttributes()
                        .font(Font.Poppins.bold(size: 20.scale))
                        .lineHeight(25.scale)
                        .letterSpacing(0.06)
                        .textColor(UIColor(red: 17 / 255, green: 17 / 255, blue: 17 / 255, alpha: 1))),
                      caption: caption,
                      subCaption: nil,
                      save: nil,
                      bottomLine: "after 3-day trial".attributed(with: TextAttributes()
                        .font(Font.Poppins.semibold(size: 15.scale))
                        .lineHeight(25.scale)))
    }
    
    func createSpecialOffer() -> PaygateSpecialOffer {
        PaygateSpecialOffer(productId: "com.stars.specialmonthly1499",
                            title: "-50%".attributed(with: TextAttributes()
                                .font(Font.Poppins.bold(size: 52.scale))
                                .textColor(UIColor.white)
                                .lineHeight(54.scale)
                                .textAlignment(.center)),
                            subTitle: nil,
                            text: "Your guide to healthy relationships and goal setting. Price reduced!".attributed(with: TextAttributes()
                                .font(Font.OpenSans.bold(size: 22.scale))
                                .textColor(UIColor.white)
                                .lineHeight(26.scale)
                                .textAlignment(.center)),
                            time: "54:36",
                            oldPrice: "$89.99".attributed(with: TextAttributes()
                                .font(Font.Poppins.regular(size: 17.scale))
                                .lineHeight(19.scale)
                                .textColor(.white)
                                .strikethroughStyle(.single)),
                            price: "$14.59 per month".attributed(with: TextAttributes()
                                .font(Font.Poppins.bold(size: 17.scale))
                                .lineHeight(19.scale)
                                .textColor(.white)),
                            button: "CONTINUE".attributed(with: TextAttributes()
                                .font(Font.Poppins.semibold(size: 17.scale))
                                .letterSpacing(0.2.scale)
                                .textColor(UIColor.black)),
                            subButton: "Secured with iTunes.".attributed(with: TextAttributes()
                                .font(Font.OpenSans.semibold(size: 13.scale))
                                .textColor(UIColor.white.withAlphaComponent(0.5))
                                .letterSpacing(-0.06.scale)
                                .lineHeight(15.scale)),
                            restore: "Restore".attributed(with: TextAttributes()
                                .font(Font.OpenSans.semibold(size: 17.scale))
                                .lineHeight(27.scale)
                                .textColor(UIColor.white.withAlphaComponent(0.3))))
    }
}
