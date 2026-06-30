//
//  DetailSegmentView.swift
//  MovieAppSwiftUI
//
//  Created by Nishad Zulfuqarli on 30.06.26.
//

import SwiftUI

struct DetailSegmentView: View {
    var body: some View {
        VStack {
            segmentView

            switch selectedSegment {
            case 0: aboutMovie
            case 1: reviewsView
            case 2: castView
            default: EmptyView()

            }
        }

    }

    let movieId: Int

    @ObservedObject var detailViewModel: DetailViewModel

    @ObservedObject var detailSegmentViewModel: DetailSegmentViewModel

    @State private var selectedSegment: Int = 0

    @Namespace private var SegmentAnimation

    private let segmentLabel: [String] = ["About Moview", "Reviews", "Cast"]

    @State private var expandedReviews: Set<String> = []

    let column = [GridItem(.flexible()), GridItem(.flexible())]

}


extension DetailSegmentView {
    @ViewBuilder
    private var segmentView: some View {
        HStack(spacing: 12) {
            ForEach(Array(segmentLabel.enumerated()), id: \.offset) { index, segment in
                VStack(spacing: 4) {
                    Text(segment)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .font(.system(size: 16))
                        .onTapGesture { selectedSegment = index }

                    if selectedSegment == index {
                        Rectangle()
                            .frame(height: 2)
                            .foregroundStyle(.textFieldBackground)
                            .matchedGeometryEffect(id: "indicator", in: SegmentAnimation)
                    } else {
                        Rectangle()
                            .frame(height: 2)
                            .foregroundStyle(.clear)
                    }
                }
            }
        }
        .padding(.horizontal, 18)
        .animation(.spring(duration: 0.3), value: selectedSegment)
        .offset(y: -50)
    }

    @ViewBuilder
    private var aboutMovie: some View {
        Text(detailViewModel.movieDetail?.overview ?? "")
            .font(.system(size: 14))
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .offset(y: -45)
    }

    @ViewBuilder
    private var reviewsView: some View {
        LazyVStack(spacing: 22) {
            ForEach(detailSegmentViewModel.moviewReviews?.results ?? [], id: \.id) { review in
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        AsyncImage(url: URL(string: review.authorDetails.getFullAvatarPath ?? "")) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Image(.defaultAvatar).resizable().scaledToFill()
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(.circle)

                        Spacer()

                        Text(String(Double(review.authorDetails.rating ?? 0)))
                            .foregroundStyle(.blue)
                            .font(.system(size: 13))
                            .frame(width: 50, alignment: .center)
                    }
                    .frame(width: 51, height: 71)

                    VStack(alignment: .leading, spacing: 12) {
                        Text(review.author)
                            .foregroundStyle(.white)
                            .font(.system(size: 14, weight: .bold))

                        Text(review.content)
                            .foregroundStyle(.white)
                            .font(.system(size: 13))
                            .lineLimit(expandedReviews.contains(review.id) ? nil : 4)
                            .onTapGesture {
                                withAnimation(.spring(duration: 0.3)) {
                                    if expandedReviews.contains(review.id) {
                                        expandedReviews.remove(review.id)
                                    } else {
                                        expandedReviews.insert(review.id)
                                    }
                                }
                            }
                    }
                    .padding(.leading, 5)

                    Spacer()
                }
            }
        }
        .padding(.horizontal, 18)
        .offset(y: -40)
    }

    @ViewBuilder
    private var castView: some View {
        LazyVGrid(columns: column, spacing: 25) {
            ForEach(detailSegmentViewModel.movieCast?.cast ?? [], id: \.id) { casts in
                VStack(spacing: 12) {
                    AsyncImage(url: URL(string: casts.getCastProfileFullPath ?? "")) { image in
                        image.resizable().scaledToFill()
                            .minimumScaleFactor(0.7)
                            .offset(y: 15)
                    } placeholder: {
                        Image(.defaultAvatar).resizable().scaledToFill()
                    }
                    .frame(width: 120, height: 120)
                    .clipShape(.circle)

                    Text(casts.name)
                        .foregroundStyle(.white)
                        .font(.system(size: 18))
                }
            }
        }
        .padding(.horizontal, 18)
        .offset(y: -40)
    }
}
